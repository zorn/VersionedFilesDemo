# VersionedFilesDemo 

Demo of a SwiftUI document-based app. Trying to work out how file versions over time will work in an isolated project.

## Required Behaviors

* New File, Save, Open and all the other "default" document behaviors we get from the SDK.
* Let's assume we are saving a flat file and that file contents will be in pretty printed JSON. 
* Need to have behaviors around letting a v1 app save a v1 data format and then a v2 can open a v1 file and save it with a v2 data format. 
* When it saves we'll assume it will save as the current file schema version.
* When migrating a v1 file format to a v2 file format some data will transfer 1:1, some will need to be transformed, maybe generating new data, any new data properties, if not optional will need a default value.
* Should have a test infrastructure so we can test multiple generations of change: ie: v1 to v2 as well as v1 to v3.
* for the sake of simplicity let's chain the version imports so a v1 has to first, internally be updated to a v2 and then a v3. If this becomes costly over time we could evolve the system to provide v1 to v3 directly but that's more work out of the gate and can probably be skipped for now.
* Need to test for long imports and version conversions. What does the UI do while the document is updating?
* How does a version update failure get handled and reported? Does the user have any fallback?
* Need a way to sniff a file for it's version. Could maybe make an assumption of the `version` property at the root of the json and reject if not found. I know core data puts version meta into the file system attributes but I don't think we should count on that since people may move these files around (email, websites, etc.)

## Related Resources

* https://developer.apple.com/videos/play/wwdc2020/10039/
* https://developer.apple.com/documentation/swiftui/documentgroup
* https://developer.apple.com/documentation/uniformtypeidentifiers
* https://developer.apple.com/documentation/uniformtypeidentifiers/defining_file_and_data_types_for_your_app
