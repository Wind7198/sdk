// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*element: main:
 static=[
  testConstRedirectingFactoryInvoke(0),
  testConstRedirectingFactoryInvokeGeneric(0),
  testConstRedirectingFactoryInvokeGenericDynamic(0),
  testConstRedirectingFactoryInvokeGenericRaw(0),
  testConstructorInvoke(0),
  testConstructorInvokeGeneric(0),
  testConstructorInvokeGenericDynamic(0),
  testConstructorInvokeGenericRaw(0),
  testFactoryConstructor(0),
  testFactoryInvoke(0),
  testFactoryInvokeGeneric(0),
  testFactoryInvokeGenericDynamic(0),
  testFactoryInvokeGenericRaw(0),
  testImplicitConstructor(0),
  testRedirectingFactoryInvoke(0),
  testRedirectingFactoryInvokeGeneric(0),
  testRedirectingFactoryInvokeGenericDynamic(0),
  testRedirectingFactoryInvokeGenericRaw(0)]
*/
main() {
  testConstructorInvoke();
  testConstructorInvokeGeneric();
  testConstructorInvokeGenericRaw();
  testConstructorInvokeGenericDynamic();
  testFactoryInvoke();
  testFactoryInvokeGeneric();
  testFactoryInvokeGenericRaw();
  testFactoryInvokeGenericDynamic();
  testRedirectingFactoryInvoke();
  testRedirectingFactoryInvokeGeneric();
  testRedirectingFactoryInvokeGenericRaw();
  testRedirectingFactoryInvokeGenericDynamic();
  testConstRedirectingFactoryInvoke();
  testConstRedirectingFactoryInvokeGeneric();
  testConstRedirectingFactoryInvokeGenericRaw();
  testConstRedirectingFactoryInvokeGenericDynamic();
  testImplicitConstructor();
  testFactoryConstructor();
}

/*element: testConstructorInvoke:static=[Class.generative(0)]*/
testConstructorInvoke() {
  new Class.generative();
}

/*element: testConstructorInvokeGeneric:static=[GenericClass.generative(0),assertIsSubtype(5),throwTypeError(1)]*/
testConstructorInvokeGeneric() {
  new GenericClass<int, String>.generative();
}

/*element: testConstructorInvokeGenericRaw:static=[GenericClass.generative(0)]*/
testConstructorInvokeGenericRaw() {
  new GenericClass.generative();
}

/*element: testConstructorInvokeGenericDynamic:static=[GenericClass.generative(0)]*/
testConstructorInvokeGenericDynamic() {
  new GenericClass<dynamic, dynamic>.generative();
}

/*element: testFactoryInvoke:static=[Class.fact(0)]*/
testFactoryInvoke() {
  new Class.fact();
}

/*element: testFactoryInvokeGeneric:static=[GenericClass.fact(0),assertIsSubtype(5),throwTypeError(1)]*/
testFactoryInvokeGeneric() {
  new GenericClass<int, String>.fact();
}

/*element: testFactoryInvokeGenericRaw:static=[GenericClass.fact(0)]*/
testFactoryInvokeGenericRaw() {
  new GenericClass.fact();
}

/*element: testFactoryInvokeGenericDynamic:static=[GenericClass.fact(0)]*/
testFactoryInvokeGenericDynamic() {
  new GenericClass<dynamic, dynamic>.fact();
}

/*element: testRedirectingFactoryInvoke:static=[Class.generative(0)]*/
testRedirectingFactoryInvoke() {
  new Class.redirect();
}

/*element: testRedirectingFactoryInvokeGeneric:static=[GenericClass.generative(0),assertIsSubtype(5),throwTypeError(1)]*/
testRedirectingFactoryInvokeGeneric() {
  new GenericClass<int, String>.redirect();
}

/*element: testRedirectingFactoryInvokeGenericRaw:static=[GenericClass.generative(0)]*/
testRedirectingFactoryInvokeGenericRaw() {
  new GenericClass.redirect();
}

/*element: testRedirectingFactoryInvokeGenericDynamic:static=[GenericClass.generative(0)]*/
testRedirectingFactoryInvokeGenericDynamic() {
  new GenericClass<dynamic, dynamic>.redirect();
}

/*strong.element: testConstRedirectingFactoryInvoke:static=[Class.generative(0)]*/
/*strongConst.element: testConstRedirectingFactoryInvoke:type=[const:Class]*/
testConstRedirectingFactoryInvoke() {
  const Class.redirect();
}

/*strong.element: testConstRedirectingFactoryInvokeGeneric:static=[GenericClass.generative(0),assertIsSubtype(5),throwTypeError(1)]*/
/*strongConst.element: testConstRedirectingFactoryInvokeGeneric:type=[const:GenericClass<int,String>]*/
testConstRedirectingFactoryInvokeGeneric() {
  const GenericClass<int, String>.redirect();
}

/*strong.element: testConstRedirectingFactoryInvokeGenericRaw:static=[GenericClass.generative(0)]*/
/*strongConst.element: testConstRedirectingFactoryInvokeGenericRaw:type=[const:GenericClass<dynamic,dynamic>]*/
testConstRedirectingFactoryInvokeGenericRaw() {
  const GenericClass.redirect();
}

/*strong.element: testConstRedirectingFactoryInvokeGenericDynamic:static=[GenericClass.generative(0)]*/
/*strongConst.element: testConstRedirectingFactoryInvokeGenericDynamic:type=[const:GenericClass<dynamic,dynamic>]*/
testConstRedirectingFactoryInvokeGenericDynamic() {
  const GenericClass<dynamic, dynamic>.redirect();
}

/*element: ClassImplicitConstructor.:static=[Object.(0)]*/
class ClassImplicitConstructor {}

/*element: testImplicitConstructor:static=[ClassImplicitConstructor.(0)]*/
testImplicitConstructor() => new ClassImplicitConstructor();

class ClassFactoryConstructor {
  /*element: ClassFactoryConstructor.:type=[inst:JSNull]*/
  factory ClassFactoryConstructor() => null;
}

/*element: testFactoryConstructor:static=[ClassFactoryConstructor.(0)]*/
testFactoryConstructor() => new ClassFactoryConstructor();

class Class {
  /*element: Class.generative:static=[Object.(0)]*/
  const Class.generative();

  /*element: Class.fact:type=[inst:JSNull]*/
  factory Class.fact() => null;

  const factory Class.redirect() = Class.generative;
}

class GenericClass<X, Y> {
  /*element: GenericClass.generative:static=[Object.(0)]*/
  const GenericClass.generative();

  /*element: GenericClass.fact:type=[inst:JSBool,inst:JSNull,param:Object]*/
  factory GenericClass.fact() => null;

  const factory GenericClass.redirect() = GenericClass<X, Y>.generative;
}
