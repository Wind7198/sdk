// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class A {}

class B {}

class C {}

class D {}

class E {}

/*element: Class1.:static=[Object.(0)]*/
class Class1 {
  /*element: Class1.field1:type=[inst:JSBool,inst:JSNull,param:A]*/
  A field1;
}

/*element: method1:
 dynamic=[Class1.field1=],
 type=[
  impl:A,
  inst:JSBool,
  is:Class1]
*/
method1(dynamic o, dynamic value) {
  if (o is! Class1) return;
  o.field1 = value;
}

/*element: Class2.:static=[Object.(0)]*/
class Class2<T> {
  /*element: Class2.field2:
   static=*,
   type=[inst:*,param:Class2.T]
   */
  T field2;
}

/*element: method2:
 dynamic=[Class2.field2=],
 static=*,
 type=[
  impl:A,
  inst:*,
  is:Class2<A>]
*/
method2(dynamic o, dynamic value) {
  if (o is! Class2<A>) return;
  o.field2 = value;
}

/*element: Class3.:static=[Object.(0)]*/
class Class3 {
  /*element: Class3.method3:type=[inst:JSBool,inst:JSNull,param:A,param:B,param:C]*/
  method3(A a, [B b, C c]) {}
}

/*element: method3:
 dynamic=[Class3.method3(3)],
 type=[
  impl:A,
  impl:C,
  inst:JSBool,
  is:Class3,
  param:B]
*/
method3(dynamic o, dynamic a, B b, dynamic c) {
  if (o is! Class3) return;
  o.method3(a, b, c);
}

/*element: Class4.:static=[Object.(0)]*/
class Class4 {
  /*element: Class4.method4:
   type=[inst:JSBool,inst:JSNull,param:A,param:B,param:C]
  */
  method4(A a, {B b, C c}) {}
}

/*element: method4:
 dynamic=[Class4.method4(1,b,c)],
 type=[
  impl:A,
  impl:C,
  inst:JSBool,
  is:Class4,
  param:B]
*/
method4(dynamic o, dynamic a, B b, dynamic c) {
  if (o is! Class4) return;
  o.method4(a, c: c, b: b);
}

/*element: Class5.:static=[Object.(0)]*/
class Class5<T1, T2> {
  /*element: Class5.method5:
   static=*,
   type=[
    inst:*,
    param:C,
    param:Class5.T1,
    param:Class5.T2,
    param:Object,
    param:method5.S1,
    param:method5.S2]
  */
  method5<S1, S2>(T1 a, [T2 b, C c, S1 d, S2 e]) {}
}

/*element: method5:
 dynamic=[Class5.method5<D,E>(5)],
 static=*,
 type=[
  impl:A,
  impl:D,
  inst:*,
  is:Class5<A,B>,
  param:B,
  param:C,
  param:E]
*/
method5(dynamic o, dynamic a, B b, C c, dynamic d, E e) {
  if (o is! Class5<A, B>) return;
  o.method5<D, E>(a, b, c, d, e);
}

/*element: Class6.:static=[Object.(0)]*/
class Class6<T1, T2> {
  /*element: Class6.method6:
   static=*,
   type=[
    inst:*,
    param:C,
    param:Class6.T1,
    param:Class6.T2,
    param:Object,
    param:method6.S1,
    param:method6.S2]
  */
  method6<S1, S2>(T1 a, {T2 b, C c, S1 d, S2 e}) {}
}

/*element: method6:
 dynamic=[Class6.method6<D,E>(1,b,c,d,e)],
 static=*,
 type=[
  impl:A,
  impl:D,
  inst:*,
  is:Class6<A,B>,
  param:B,
  param:C,
  param:E]
*/
method6(dynamic o, dynamic a, B b, C c, dynamic d, E e) {
  if (o is! Class6<A, B>) return;
  o.method6<D, E>(a, d: d, b: b, e: e, c: c);
}

/*element: Class7.:static=[Object.(0)]*/
class Class7 {
  /*element: Class7.f:type=[inst:JSNull]*/
  A Function(A) get f => null;
}

/*element: method7:
 dynamic=[Class7.f(1),call(1)],
 type=[impl:A,inst:JSBool,is:Class7]
*/
method7(dynamic o, dynamic a) {
  if (o is! Class7) return;
  o.f(a);
}

/*element: F.:static=[Object.(0)]*/
class F<T> {
  /*element: F.method:static=*,type=[inst:*,param:List<F.T>]*/
  T method(List<T> list) => null;

  /*element: F.field:static=*,type=[inst:*,param:F.T]*/
  T field;
}

/*element: G.:static=[F.(0)]*/
class G extends F<int> {}

/*element: method8:
 dynamic=[G.method(1)],
 static=*,
 type=[impl:List<int>,inst:*,is:G,param:Iterable<int>]
*/
method8(dynamic g, Iterable<int> iterable) {
  if (g is! G) return null;
  return g.method(iterable);
}

/*element: method9:
 dynamic=[G.field=],
 type=[impl:int,inst:JSBool,inst:JSNull,is:G,param:num]
*/
method9(dynamic g, num value) {
  if (g is! G) return null;
  return g.field = value;
}

/*element: main:**/
main() {
  method1(new Class1(), null);
  method2(new Class2<A>(), null);
  method3(new Class3(), null, null, null);
  method4(new Class4(), null, null, null);
  method5(new Class5<A, B>(), null, null, null, null, null);
  method6(new Class6<A, B>(), null, null, null, null, null);
  method7(new Class7(), null);
  method8(new G(), null);
  method9(new G(), null);
}
