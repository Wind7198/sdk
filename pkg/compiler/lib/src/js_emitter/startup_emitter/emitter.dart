// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart2js.js_emitter.startup_emitter;

import 'package:js_runtime/shared/embedded_names.dart'
    show JsBuiltin, METADATA, TYPES;

import '../../../compiler_new.dart';
import '../../common.dart';
import '../../common/tasks.dart';
import '../../constants/values.dart' show ConstantValue;
import '../../deferred_load.dart' show OutputUnit;
import '../../dump_info.dart';
import '../../elements/entities.dart';
import '../../io/source_information.dart';
import '../../js/js.dart' as js;
import '../../js_backend/js_backend.dart' show ModularNamer, Namer;
import '../../js_backend/runtime_types.dart';
import '../../options.dart';
import '../../universe/codegen_world_builder.dart' show CodegenWorld;
import '../../world.dart' show JClosedWorld;
import '../js_emitter.dart' show Emitter, ModularEmitter;
import '../model.dart';
import '../program_builder/program_builder.dart' show ProgramBuilder;
import 'model_emitter.dart';

class ModularEmitterImpl implements ModularEmitter {
  final ModularNamer _namer;

  ModularEmitterImpl(this._namer);

  js.PropertyAccess globalPropertyAccessForClass(ClassEntity element) {
    js.Name name = _namer.globalPropertyNameForClass(element);
    js.PropertyAccess pa =
        new js.PropertyAccess(_namer.readGlobalObjectForClass(element), name);
    return pa;
  }

  js.PropertyAccess globalPropertyAccessForType(Entity element) {
    js.Name name = _namer.globalPropertyNameForType(element);
    js.PropertyAccess pa =
        new js.PropertyAccess(_namer.readGlobalObjectForType(element), name);
    return pa;
  }

  js.PropertyAccess globalPropertyAccessForMember(MemberEntity element) {
    js.Name name = _namer.globalPropertyNameForMember(element);
    js.PropertyAccess pa =
        new js.PropertyAccess(_namer.readGlobalObjectForMember(element), name);
    return pa;
  }

  @override
  js.PropertyAccess constructorAccess(ClassEntity element) {
    return globalPropertyAccessForClass(element);
  }

  @override
  js.Expression isolateLazyInitializerAccess(FieldEntity element) {
    return new js.PropertyAccess(_namer.readGlobalObjectForMember(element),
        _namer.lazyInitializerName(element));
  }

  @override
  js.PropertyAccess staticFunctionAccess(FunctionEntity element) {
    return globalPropertyAccessForMember(element);
  }

  @override
  js.PropertyAccess staticFieldAccess(FieldEntity element) {
    return globalPropertyAccessForMember(element);
  }

  @override
  js.PropertyAccess prototypeAccess(ClassEntity element,
      {bool hasBeenInstantiated}) {
    js.Expression constructor =
        hasBeenInstantiated ? constructorAccess(element) : typeAccess(element);
    return js.js('#.prototype', constructor);
  }

  js.Expression typeAccess(Entity element) {
    return globalPropertyAccessForType(element);
  }

  @override
  js.Expression staticClosureAccess(FunctionEntity element) {
    return new js.Call(
        new js.PropertyAccess(_namer.readGlobalObjectForMember(element),
            _namer.staticClosureName(element)),
        const []);
  }

  @override
  js.Expression constantReference(ConstantValue constant) {
    throw new UnimplementedError("ModularEmitter.constantReference");
  }

  @override
  js.Expression generateEmbeddedGlobalAccess(String global) {
    throw new UnimplementedError("ModularEmitter.generateEmbeddedGlobalAccess");
  }
}

class EmitterImpl extends ModularEmitterImpl implements Emitter {
  final DiagnosticReporter _reporter;
  final JClosedWorld _closedWorld;
  final RuntimeTypesEncoder _rtiEncoder;
  ModelEmitter _emitter;

  @override
  Program programForTesting;

  EmitterImpl(
      CompilerOptions options,
      this._reporter,
      CompilerOutput outputProvider,
      DumpInfoTask dumpInfoTask,
      Namer namer,
      this._closedWorld,
      this._rtiEncoder,
      SourceInformationStrategy sourceInformationStrategy,
      CompilerTask task,
      bool shouldGenerateSourceMap)
      : super(namer) {
    _emitter = new ModelEmitter(
        options,
        _reporter,
        outputProvider,
        dumpInfoTask,
        namer,
        _closedWorld,
        task,
        this,
        sourceInformationStrategy,
        _rtiEncoder,
        shouldGenerateSourceMap);
  }

  @override
  Namer get _namer => super._namer;

  @override
  int emitProgram(ProgramBuilder programBuilder, CodegenWorld codegenWorld) {
    Program program = programBuilder.buildProgram();
    if (retainDataForTesting) {
      programForTesting = program;
    }
    return _emitter.emitProgram(program, codegenWorld);
  }

  @override
  js.Expression interceptorClassAccess(ClassEntity element) {
    return globalPropertyAccessForClass(element);
  }

  @override
  bool isConstantInlinedOrAlreadyEmitted(ConstantValue constant) {
    return _emitter.isConstantInlinedOrAlreadyEmitted(constant);
  }

  @override
  int compareConstants(ConstantValue a, ConstantValue b) {
    return _emitter.compareConstants(a, b);
  }

  @override
  js.Expression constantReference(ConstantValue value) {
    return _emitter.generateConstantReference(value);
  }

  @override
  js.Expression generateEmbeddedGlobalAccess(String global) {
    return _emitter.generateEmbeddedGlobalAccess(global);
  }

  @override
  // TODO(herhut): Use a single shared function.
  js.Expression generateFunctionThatReturnsNull() {
    return js.js('function() {}');
  }

  @override
  js.Expression interceptorPrototypeAccess(ClassEntity e) {
    return js.js('#.prototype', interceptorClassAccess(e));
  }

  @override
  js.Template templateForBuiltin(JsBuiltin builtin) {
    switch (builtin) {
      case JsBuiltin.dartObjectConstructor:
        ClassEntity objectClass = _closedWorld.commonElements.objectClass;
        return js.js.expressionTemplateYielding(typeAccess(objectClass));

      case JsBuiltin.isCheckPropertyToJsConstructorName:
        int isPrefixLength = _namer.operatorIsPrefix.length;
        return js.js.expressionTemplateFor('#.substring($isPrefixLength)');

      case JsBuiltin.isFunctionType:
        return _rtiEncoder.templateForIsFunctionType;

      case JsBuiltin.isFutureOrType:
        return _rtiEncoder.templateForIsFutureOrType;

      case JsBuiltin.isVoidType:
        return _rtiEncoder.templateForIsVoidType;

      case JsBuiltin.isDynamicType:
        return _rtiEncoder.templateForIsDynamicType;

      case JsBuiltin.isJsInteropTypeArgument:
        return _rtiEncoder.templateForIsJsInteropTypeArgument;

      case JsBuiltin.rawRtiToJsConstructorName:
        return js.js.expressionTemplateFor("#.name");

      case JsBuiltin.rawRuntimeType:
        return js.js.expressionTemplateFor("#.constructor");

      case JsBuiltin.isSubtype:
        // TODO(floitsch): move this closer to where is-check properties are
        // built.
        String isPrefix = _namer.operatorIsPrefix;
        return js.js.expressionTemplateFor("('$isPrefix' + #) in #.prototype");

      case JsBuiltin.isGivenTypeRti:
        return js.js.expressionTemplateFor('#.name === #');

      case JsBuiltin.getMetadata:
        String metadataAccess =
            _emitter.generateEmbeddedGlobalAccessString(METADATA);
        return js.js.expressionTemplateFor("$metadataAccess[#]");

      case JsBuiltin.getType:
        String typesAccess = _emitter.generateEmbeddedGlobalAccessString(TYPES);
        return js.js.expressionTemplateFor("$typesAccess[#]");

      default:
        _reporter.internalError(
            NO_LOCATION_SPANNABLE, "Unhandled Builtin: $builtin");
        return null;
    }
  }

  @override
  int generatedSize(OutputUnit unit) {
    if (_emitter.omittedFragments.any((f) => f.outputUnit == unit)) {
      return 0;
    }
    Fragment key = _emitter.outputBuffers.keys
        .firstWhere((Fragment fragment) => fragment.outputUnit == unit);
    return _emitter.outputBuffers[key].length;
  }
}
