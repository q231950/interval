# IBM Swift Buildpack

## Setting up Bluemix

### Create a manifest file

**Sign in to bluemix:**

`bx login <the@email.address>`

**Target the `-o`, organisation and `-s`, the space:**

`bx target -o elbedev -s dev`

**Add the manifest:**

`bx cf create-app-manifest interval`

This results in _interval_manifest.yml_. I looked at the Kitura Example App's manifest and [added](465b57db983737cb4a47519e7857ab88bcbef96f) the `buildpack: swift_buildpack`. This resulted in this manifest:

```yaml
applications:
- name: interval
  disk_quota: 1G
  instances: 1
  memory: 256M
  routes:
  - route: interval.eu-de.mybluemix.net
  stack: cflinuxfs2
  buildpack: swift_buildpack
```

## Setting up dependencies

**Swift Packages**

[Create](d1abff1330e7a8c6edf0730d5ab13bfc09659042) _Package.swift_ which will have one target, the Kitura app. There is one product, _interval_ with its 2 targets _interval_ and _Controller_.

The package specifies the following third party dependencies as a minimum requirement:

- Kitura: the web framework itself
- CloudEnvironment
- HeliumLogger

## Setting up Sources/Tests

[Add](c8860fd6e8d40a4b87a8c6eb7603f956d820b643) sources for `interval` and `Controller` and tests for `ControllerTests`.

```bash
.
├── Package.resolved
├── Package.swift
├── Readme.md
├── Sources
│   ├── Controller
│   │   └── Controller.swift
│   └── interval
│       └── main.swift
├── Tests
│   ├── ControllerTests
│   │   └── ControllerTests.swift
│   └── LinuxMain.swift
├── documentation
│   └── ibm-swift-buildpack.md
└── interval_manifest.yml
```

Once this is setup, it can be built for the first time. This will download the dependencies and compile the _interval_ app. Note that Kitura [requires](73ae4d07f08eaffefd327f591f220bb00ee98469) (at the time of writing) Swift 4.0.3, so Xcode 9.2.

**Build the app:**

`swift build`

**Run the app**

```bash
macbook:interval kim$ ./.build/x86_64-apple-macosx10.10/debug/interval
[2018-04-11T22:18:27.087+02:00] [WARNING] [ConfigurationManager.swift:261 load(url:deserializerName:)] Unable to load data from URL /Users/kim/Development/interval/config/mappings.json
[2018-04-11T22:18:27.098+02:00] [INFO] [main.swift:14 interval] Server will be started on 'http://localhost:8080'.
[2018-04-11T22:18:27.101+02:00] [INFO] [HTTPServer.swift:124 listen(on:)] Listening on port 8080

```

The app is now running on _localhost:8080_. Exit with Ctrl-C.

## Deploy the build

At first, I removed the Swift Package Manager's `.build` folder. _.files_ and _.directories_ are not ignored by the `bx app push` command by default, so removing them will save you a considerable amount of time during the upload. You can ignore a directory or folder with a `.cfignore` file in the root of the repository.

**Upload the app**

`bx app push -f interval_manifest.yml`

Then there comes an interesting error log:

`Error restarting application: StagingTimeExpired`

More info can be retrieved with `bx cf logs interval --recent`, which is not very informative:

```bash
...
   2018-04-11T22:32:48.49+0200 [STG/0] OUT -----> Getting swift-4.0.3
   2018-04-11T22:32:49.90+0200 [STG/0] OUT        Cached swift-4.0.3
   2018-04-11T22:32:49.91+0200 [STG/0] OUT -----> Unpacking swift-4.0.3.tar.gz
   2018-04-11T22:32:56.65+0200 [STG/0] OUT -----> Getting clang-4.0.0
   2018-04-11T22:32:59.93+0200 [STG/0] OUT        Cached clang-4.0.0
   2018-04-11T22:32:59.93+0200 [STG/0] OUT -----> Unpacking clang-4.0.0.tar.xz
```

Looking into the Cloud Foundry App itself in the IBM Cloud reveals that somewhere is a `error:MissingLinuxMain`. This error led me to [this stack overflow answer](https://stackoverflow.com/a/46693484) by Ole Begemann. Since I had a _LinuxMain.swift_ it took me a while until I figured out that it was in the _ControllerTests_ directory, not the root of the _Tests_ directory 🤦🏻‍♂️

Once that was fixed, the app was pushed to IBM by `bx app push interval -f interval_manifest.yml` and the app was available at the route stated in the routes section of the manifest.

```yaml
routes:
  - route: interval.eu-de.mybluemix.net
```

## Celebrate

Finally, you have a Kitura app running in the IBM Cloud 🎉
