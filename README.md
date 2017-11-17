# BxObjC

This framework will help iOS developers for simplify development iOS Application

# Subframeworks:

* Common - firstly components for all others commponents: Images, Colors, File system, other...

* Data - components for data processing: serializations, dataSets, cashers, network, other...

* DB - components for object oriented access to sqlite

* Map - cartography components: geomaping

* VCL - visual components library: navigation, keyboard, progress, view lists, other...


# CocoaPods

You can use all features of this framework as

<code><pre>
  pod 'BxObjC'
</pre></code>

or use subframeworks as

<code><pre>
  pod 'BxObjC/Common'
  pod 'BxObjC/Data'
  pod 'BxObjC/DB'
  pod 'BxObjC/Map'
  pod 'BxObjC/Vcl'
</pre></code>

Vcl subframework has subsubmodules that can also be used as seporated module.
That's it:

<code><pre>
  pod 'BxObjC/Control/Rate'
  pod 'BxObjC/Control/TextView'
  pod 'BxObjC/Control/ShakeAnimation'
  pod 'BxObjC/Control/Navigation'
</pre></code>

# License

Library is distributed under the MIT license
