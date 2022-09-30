# SwiftTestUtils

This library contains utility functions and classes used to assist in Swift tests.

## TestStrings

This class is used to store and retreive sensetive strings such as keys, passwords and IP addresses in a .json file outside of your project so that you no longer have to scour through your code to remove hard-coded personal details before pushing to Git.

### Usage

1. Initialize the class by giving it a URL or string path relative to either the user's Application Support directory or Home directory with the file name included.
```
  guard let testStrings = try TestStrings(jsonPathFromApplicationSupportDirectory: "SwiftTestUtils/strings.json") else {
      // handle error
      return
  }
```

2. create the .json file and add a name and value pair.
```
  try testStrings.addValue(name: "test", value: "testValue")
```

3. Once the file is created and all the needed name/value pairs are created, you can retreive any previously added values by name.
```
  let value = testString.fetchValue(name: "test")
```

optional: if you wish to remove a name/value pair from the .json file, you can do the following:
```
  try testString.removeValue(name: "test")
```
