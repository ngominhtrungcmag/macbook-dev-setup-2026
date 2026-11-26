# Configure your toolchains

## Git and GitHub

Set your own identity. Use your GitHub no-reply email if you prefer not to publish your personal address.

```bash
git config --global user.name "Your Name"
git config --global user.email "YOUR_GITHUB_NOREPLY_EMAIL"
gh auth login
```

If you prefer SSH, follow [GitHub's SSH guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh). Use an encrypted key, add only its public part to GitHub and keep the private key out of Git. Do not publish `gh auth token` output or credentials.

## Shell and version management

macOS uses zsh by default. Review your existing `~/.zshrc`, then add the following line once if you want mise to manage your interactive shell:

```zsh
eval "$(mise activate zsh)"
```

Open a new terminal. See [mise documentation](https://mise.jdx.dev/) for version files and shims. Do not automatically replace your existing shell configuration.

## Frontend: Node.js and TypeScript

As of 25 November 2026, Node.js 26 and 24 are LTS branches. Prefer your project's version over a workstation default.

```bash
mise install node@26
mise exec node@26 -- node --version
# Optional: set the workstation-wide default (changes mise configuration).
mise use -g node@26
node --version
npm --version
```

For a repository you control, `mise use node@26` writes or updates its project configuration; commit that file only if your team agrees. Use `npm ci` for a project with an npm lockfile. For pnpm or Yarn, follow the package manager's official installation instructions and the project's declared version. Never assume every project uses the latest major version.

## .NET, C#, ASP.NET Core and Blazor

The `dotnet` profile requests `dotnet-sdk@10` via Homebrew. Homebrew lists the unversioned SDK cask as a dependency, so a current SDK may also be installed. If you only want SDK 10, use Microsoft's official .NET 10 installer instead of this profile. Check the [macOS support table](https://learn.microsoft.com/en-us/dotnet/core/install/macos) and [download page](https://dotnet.microsoft.com/download/dotnet/10.0) first.

```bash
dotnet --info
dotnet --list-sdks
```

For VS Code, install the C# tooling appropriate to your license and project. You can use the Extensions UI or, after making `code` available on PATH:

```bash
code --install-extension ms-dotnettools.csdevkit
```

Review the extension's licensing terms. Rider is an optional alternative: https://www.jetbrains.com/rider/.

For local HTTPS, explicitly trust the developer certificate only on your own authorized workstation:

```bash
dotnet dev-certs https --trust
```

Create a smoke-test Blazor project in a new directory (do not overwrite an existing project):

```bash
dotnet new blazor -f net10.0 -o BlazorSmokeTest
cd BlazorSmokeTest
dotnet run
```

Use the local URL printed in the terminal. If the current SDK is newer than the target project, use the project's `global.json` and a compatible SDK.

## Mobile: iOS, Android and .NET MAUI

1. Install a compatible Xcode release from the App Store or Apple Developer downloads: https://developer.apple.com/xcode/.
2. Launch Xcode, accept its license, install required platform SDKs and configure simulators. Use `xcodebuild -version` to verify the active full Xcode installation.
3. Open Android Studio and install the Android SDK, platform tools, emulator and the project-required build tools from SDK Manager. Prefer ARM64 emulator images on Apple Silicon when available.
4. Confirm Xcode, Java, Android SDK and the .NET SDK feature band match the mobile project's requirements before installing MAUI workloads. See https://learn.microsoft.com/en-us/dotnet/maui/get-started/installation.

```bash
# Run from the project directory with its intended SDK selected.
dotnet workload restore
```

If you are starting a new MAUI project, consult the MAUI documentation for the correct workload command and SDK/Xcode compatibility. Device provisioning, signing and account enrollment are manual. Do not commit certificates or signing credentials.

## Containers and DevOps

The devops profile includes Colima, the Docker CLI and the Compose plugin package. It does not start a VM automatically. Read `brew info docker-compose` and follow the caveats for registering the Compose CLI plugin. Do not overwrite an existing `~/.docker/config.json`; preserve existing settings.

```bash
colima start
# Check the selected Docker context before running commands.
docker context ls
docker info
docker compose version
docker run --rm hello-world
```

If Docker points to another engine, select the intended context only after confirming it exists. Stop Colima when not needed (`colima stop`). Do not run `colima delete` or Docker prune commands without backing up data and reviewing what will be removed. Kubernetes credentials and cloud logins are not automated.

## Python

```bash
uv python install 3.13
# In your existing project, follow its README and Python version constraints.
uv sync
```

For a new project, `uv init` creates a project; use it only in a directory intended for that purpose. Python 3.13 is an example baseline, not a claim that it is the latest version.

## Reference documentation

- https://docs.brew.sh/Brew-Bundle-and-Brewfile
- https://formulae.brew.sh/cask/dotnet-sdk@10
- https://learn.microsoft.com/en-us/dotnet/core/releases-and-support
- https://nodejs.org/en/about/previous-releases
- https://colima.run/
- https://docs.astral.sh/uv/