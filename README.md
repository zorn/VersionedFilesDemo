# VersionedFilesDemo 

The following project is a demo of a SwiftUI document-based app that stores it's document content in a JSON file.

Note: SwiftUI is still a bit of a moving target. This demo works as of Xcode 12 beta 6.

The problem we are modeling is how to migrate an ever changing document file schema over time.

The solution we've come up with is the introduction of `PeopleDocumentFileRepresentation` which will own the serialization aspects of `PeopleDocument` to and from disk.

`PeopleDocumentFileRepresentation` is itself `Codable` and is the thing we actually serialize and store on disk. The idea is `PeopleDocument` can create an instance of `PeopleDocumentFileRepresentation`  based on the `data` it gets from the `FileWrapper` and then cherry pick out the business domain objects it needs out of it to popular `PeopleDocument`.

When  `PeopleDocumentFileRepresentation` is decoding it will attempt to decode into the current schema version and only when it fails will it attempt to sniff the `JSONContent` for its `schemaVersion` and then run the appropriate migrations. As a developer, as you change the file format / schema you'll write migrators, demoed in `MigrateV1toV2` and `MigrateV2toV3`. These migrations surgically edit the JSONContent to make it match expectations. We highly recommend writing unit tests around these migrations to make them more trustworthy.

## Required Behaviors

* New File, Save, Open and all the other "default" iOS document behaviors we get from the SDK.
* Let's assume we are saving a flat file and that file contents will be in pretty printed JSON. 
* Need to have behaviors around letting a v1 app save a v1 data format and then a v2 can open a v1 file and save it with a v2 data format. 
* When it saves we'll assume it will save as the current file schema version.
* When migrating a v1 file format to a v2 file format some data will transfer 1:1, some will need to be transformed, maybe generating new data, any new data properties, if not optional will need a default value.
* Should have a test infrastructure so we can test multiple generations of change: ie: v1 to v2 as well as v1 to v3.
* For the sake of simplicity let's chain the version imports so a v1 has to first, internally be updated to a v2 and then a v3. If this becomes costly over time we could evolve the system to provide v1 to v3 directly but that's more work out of the gate and can probably be skipped for now.
* Need to test for long imports and version conversions. What does the UI do while the document is updating? (Looks like iOS is ok with showing a progress spinner.)
* How does a version update failure get handled and reported? Does the user have any fallback?

## Future Ideas

* Currently the way we sniff a `JSONContent` for the the `schemaVersion` is rather expensive. I did look into storing the `schemaVersion` in some file metadata but had issues with `FileWrapper`'s `fileAttributes` collection not mirroring the API calls I saw in `FileManager`.
* If I were building out a real app, I would try to enable the user to post a bug report and share any file that can not be opened properly.
* It might be better if `PeopleDocumentFileRepresentation` threw in production during `decode` if the expected schemaVersion was not provided. This would require writing our own `decode` and not use the synthesised `Codable` version.

## Related Resources

* https://developer.apple.com/videos/play/wwdc2020/10039/
* https://developer.apple.com/documentation/swiftui/documentgroup
* https://developer.apple.com/documentation/uniformtypeidentifiers
* https://developer.apple.com/documentation/uniformtypeidentifiers/defining_file_and_data_types_for_your_app

## Other Notes

* While the type safety of Swift leaned me to attempt to create `V1.Person` and `V2.Person` that felt like it was getting out of hand quickly and added a burden to the dev when making schema adjustments. I suspect there may be ways to better utilize Swift type safety compared to what I'm currently doing and welcome suggestions.
* I had trouble getting the tests working and had to add the source files to the test target which should not be required.
