# Shunpo with Nix ❄️
A nix flake for Shunpo is provided at `nix/flake.nix`.  The nix flake can either be built for testing, or fully installed.

Building
---   
1. Within the `nix/` directory, run `nix build .` which will generate a folder called `result/`.  
2. Intialize Shunpo by running `source result/bin/shunpo_init`.

Installation
---
To install Shunpo using the nix flake,
1. Run `nix install .#shunpo` within the `nix/` directory.
2. Start a new terminal session and initialize Shunpo by running `source shunpo_init`.
3. If you would like to have Shunpo initialize automatically, run the command below, which will append a line to your `.bashrc` to `source` the initialization file.
```
echo "source shunpo_init" >> ~/.bashrc
```
