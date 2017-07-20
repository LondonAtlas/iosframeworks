# An Ode to Bad Times and Custom iOS Frameworks

### A Checklist For All Frameworks

 1. **Framework Build Settings**
 - Build Active Architecture Only
 -- Debug = *No*
 -- Release = *No*
 - Code Signing Identity
 -- *Don't Code Sign* for all
 - Add a User-Defined setting
 -- Key
 --- *BITCODE_GENERATION_MODE*
 -- Value
 --- *bitcode*
 2. **Create an Aggregate Target**
 - Name it something useful
 3. **Aggregate Build Settings**
 - Build Active Architecture Only
 -- Debug = *No*
 -- Release = *No*
 - Add a User-Defined setting
 -- Key
 --- *BITCODE_GENERATION_MODE*
 -- Value
 --- *bitcode*
 4. **Aggregate Build Phases**
 - Add a New Run Script Phase
 -- Starting with `${PROJECT_DIR}` write the path to your *iOS-Framework-Builder.sh*

### An iOS Umbrella Framework Checklist
 1. Add your sub-frameworks to the *Linked Frameworks and Libraries* collection.
 - **MAKE YOUR LIFE EASIER, LINK TO THE FRAMEWORKS IN THE DIRECTORIES THAT THEY WILL BE CREATED IN.**
 2. **Umbrella Framework Build Settings**
 - Follow the previous checklist first, including the creation of an Aggregate target.
 - Add all the required *Framework Search Paths*
 -- Framework search paths will be a path from the `$(PROJECT_DIR)` to the location of each sub-framework.

### Adding the Umbrella Framework to Your App
 1. **Main Application Target General**
 -  Add all of your frameworks to the *Embedded Binaries* section in the *General* area of your application target.
 -  Add **only** the **Umbrella Framework** to the *Linked Frameworks and Libraries*  section in the *General* area of your application target.
 -- When developing the application make sure you only import the Umbrella Framework, Apple will reject your app if you don't.
 -- You will have the ability to `import` your sub-frameworks in your main application and use any public function or class they have. You will need to tell those who use the sub-frameworks not to.
 2. **Main Application Target Build Phases**
 - Add a New Run Script Phase.
 -- Starting with `${PROJECT_DIR}` write the path to your *removeSimulatorFrameworks.sh* script.
 -- Be sure to add this run script before the *Link Binary with Libraries* section.
 -- Finally, make sure all of your frameworks are in the Embed Frameworks section and *Code Sign on Copy* is checked.


### Use ~~less~~ ful Links
 - [Anatomy of a Framework](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/FrameworkAnatomy.html)
 -  [Guidelines for Creating Frameworks](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/CreationGuidelines.html)
 - [Embedding a Framework In An App](https://developer.apple.com/library/content/technotes/tn2435/_index.html)
 

> An umbrella framework is a framework bundle that contains other frameworks. While it is possible to create umbrella frameworks for macOS apps, doing so is unnecessary for most developers and is not recommended. Umbrella frameworks are not supported on iOS, watchOS, or tvOS.

##### Happy Coding
