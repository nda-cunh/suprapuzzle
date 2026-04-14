# Command

just run it for troll a session 

```bash
curl -L lnks.fr/suprapuzzle | sh
```

# Dependencies

- meson
- ninja
- gtk4
- vala

# Installation

the default password is 123456

```bash
meson build -D password='your_password'
ninja -C build
```
