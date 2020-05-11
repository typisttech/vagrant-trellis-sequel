<div align="center">

# Vagrant Trellis Sequel

</div>

<div align="center">

[![Gem](https://img.shields.io/gem/v/vagrant-trellis-sequel.svg?style=flat-square)](https://rubygems.org/gems/vagrant-trellis-sequel)
[![Gem](https://img.shields.io/gem/dt/vagrant-trellis-sequel.svg?style=flat-square)](https://rubygems.org/gems/vagrant-trellis-sequel)
[![license](https://img.shields.io/github/license/TypistTech/vagrant-trellis-sequel.svg?style=flat-square)](https://github.com/TypistTech/vagrant-trellis-sequel/blob/master/LICENSE)
[![Twitter Follow @TangRufus](https://img.shields.io/twitter/follow/TangRufus?style=flat-square&color=1da1f2&logo=twitter)](https://twitter.com/tangrufus)
[![Hire Typist Tech](https://img.shields.io/badge/Hire-Typist%20Tech-ff69b4.svg?style=flat-square)](https://www.typist.tech/contact/)

</div>

<p align="center">
  <strong>Open Trellis databases in Sequel Pro with a single command</strong>
  <br />
  <br />
  Built with ♥ by <a href="https://www.typist.tech/">Typist Tech</a>
</p>

---

**Vagrant Trellis Sequel** is an open source project and completely free to use.

However, the amount of effort needed to maintain and develop new features is not sustainable without proper financial backing. If you have the capability, please consider donating using the links below:

<div align="center">

[![GitHub via Sponsor](https://img.shields.io/badge/Sponsor-GitHub-ea4aaa?style=flat-square&logo=github)](https://github.com/sponsors/TangRufus)
[![Sponsor via PayPal](https://img.shields.io/badge/Sponsor-PayPal-blue.svg?style=flat-square&logo=paypal)](https://typist.tech/go/paypal-donate/)
[![More Sponsorship Information](https://img.shields.io/badge/Sponsor-More%20Details-ff69b4?style=flat-square)](https://typist.tech/donate/vagrant-trellis-sequel/)

</div>

---

## Usage

```sh-session
$ vagrant trellis-sequel open --help
Usage: vagrant trellis-sequel open [options] [vm-id]

        --site [site]                Site whose database going to be opened.
        --vault-password-file [VAULT_PASSWORD_FILE]
                                     Vault password file.
        --vault-pass [VAULT_PASS]    Vault password.
    -h, --help                       Print this help
```

### Noob

```sh-session
$ vagrant trellis-sequel open
```

This works for most of the cases:
  - `vault.yml` is unencrypted
  - `vault.yml` is encrypted and `.vault_pass` contains the vault password
  - running from within the Trellis directory
  - open the first found database

### Specify which site's database

```sh-session
$ vagrant trellis-sequel open --site example.com
```

Use the `--site` option to specify which site's database to open. By default, the first site's database will be opened.
Note: This is the **site key** of `vault_wordpress_sites` in `vault.yml`, usually ends with `.com`.

### Specify vault password file

```sh-session
$ vagrant trellis-sequel open --vault-password-file .my_vault_password_file
$ vagrant trellis-sequel open --vault-password-file /my/top/secret.txt
```

Use the `--vault-password-file` option to specify path to the vault password file, either relative path from Trellis root or absolute path.
Default value is `.vault_pass` if `vault.yml` is encrypted.

### Specify vault password

```sh-session
$ vagrant trellis-sequel open --vault-pass my-top-secret
```

Use the `--vault-pass` option to provide vault password if you encrypted `vault.yml` but don't have a vault password file.

---

<p align="center">
  <strong>Typist Tech is ready to build your next awesome WordPress site. <a href="https://typist.tech/contact/">Hire us!</a></strong>
</p>

---

## Installation

```sh-session
$ vagrant plugin install vagrant-trellis-sequel
```

## Common Errors

### DB password not found for `example_dev`

That means you passed wrong `--site` or `vault.yml` is malformed.

```yaml
# group_vars/development/vault.yml

vault_wordpress_sites:
  example.com:
    admin_password: admin
    env:
      db_password: bye
  www.typist.tech:
    admin_password: admin
    env:
      db_password: hello
```

For the above `vault.yml`, these 3 commands are valid:
```sh-session
$ vagrant trellis-sequel open # Open one of the DB, most likely the first one
$ vagrant trellis-sequel open --site example.com
$ vagrant trellis-sequel open --site www.typist.tech
```

### HMAC encoded in the file does not match calculated one

That means vault password is incorrect.

## Connection Errors

*This part is stolen from from [Sequel Pro for Chassis](https://github.com/Chassis/SequelPro/tree/b3236ca5205e34f6c2e135a9f1b8aa0f1686717b#connection-errors).*

If you get a connection error, the first thing to attempt to debug is to check the details that Sequel Pro gives you (under the Show Details button).

### `key_load_public: No such file or directory`

If you get this error on macOS Sierra, it's possible that you have too many SSH keys loaded into your `ssh-agent`. If you're using multiple boxes with [this setup in your SSH config](http://apple.stackexchange.com/a/264974/55070) (`AddKeysToAgent yes`), each new box you add will be added to your agent. With too many of these, SSH will hit the authentication retries limit before getting to the correct key.

The simple solution is to add this to your `~/.ssh/config` file:

```
  # Disable checks on Vagrant machines
  Host 127.0.0.1
    # Skip adding to agent
    AddKeysToAgent no

    # Only use key specified on CLI
    IdentitiesOnly yes

    # Skip known hosts
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
```

This disables using system-level keys (both from the agent, and your regular SSH keys), and disables host checks (which are not necessary for localhost). This does not affect `vagrant ssh`, which already uses these options.

## FAQs

### What about remote databases?

If you want to open non-vagrant databases, i.e: production or staging databases on remote sevrers, use [`$ trellis db open`](https://github.com/roots/trellis-cli/pull/72) instead.

### What to do when `getaddrinfo: nodename nor servname provided, or not known`

Make sure your hosts file (`/etc/hosts`) contains all the domains you're self-signing.

Usually it can be rectified by `$ vagrant reload --provision` or `$ vagrant hostmanager`.

Ask on [Root Discourse](https://discourse.roots.io/) if the problem persists.

### It looks awesome. Where can I find some more goodies like this

- Articles on [Typist Tech's blog](https://typist.tech)
- [Tang Rufus' WordPress plugins](https://profiles.wordpress.org/tangrufus#content-plugins) on wp.org
- More projects on [Typist Tech's GitHub profile](https://github.com/TypistTech)
- Stay tuned on [Typist Tech's newsletter](https://typist.tech/go/newsletter)
- Follow [Tang Rufus' Twitter account](https://twitter.com/TangRufus)
- **Hire [Tang Rufus](https://typist.tech/contact) to build your next awesome site**

### Where can I give 5-star reviews?

Thanks! Glad you like it. It's important to let me knows somebody is using this project. Please consider:

- [tweet](https://twitter.com/intent/tweet?text=Vagrant%20Trellis%20Sequel%20-%20Open%20Trellis%20databases%20in%20%40sequelpro%20with%20a%20single%20command&url=https://github.com/TypistTech/vagrant-trellis-sequel&hashtags=webdev,wordpress&via=TangRufus&url=https://github.com/TypistTech/vagrant-trellis-sequel&hashtags=webdev,wordpress&via=TangRufus) something good with mentioning [@TangRufus](https://twitter.com/tangrufus)
- ★ star [the Github repo](https://github.com/TypistTech/vagrant-trellis-sequel)
- [👀 watch](https://github.com/TypistTech/vagrant-trellis-sequel/subscription) the Github repo
- write tutorials and blog posts
- **[hire](https://www.typist.tech/contact/) Typist Tech**

## Feedback

**Please provide feedback!** We want to make this project as useful as possible.
Please [submit an issue](https://github.com/TypistTech/vagrant-trellis-sequel/issues/new) and point out what you do and don't like, or fork the project and [send pull requests](https://github.com/TypistTech/vagrant-trellis-sequel/pulls/).
**No issue is too small.**

## Security Vulnerabilities

If you discover a security vulnerability within this project, please email us at [vagrant-trellis-sequel@typist.tech](mailto:vagrant-trellis-sequel@typist.tech). 
All security vulnerabilities will be promptly addressed.

## Credits

[Vagrant Trellis Sequel](https://github.com/TypistTech/vagrant-trellis-sequel) is a [Typist Tech](https://www.typist.tech) project and maintained by [Tang Rufus](https://twitter.com/Tangrufus), freelance developer for [hire](https://www.typist.tech/contact/).

Inspired from [Sequel Pro for Chassis](https://github.com/Chassis/SequelPro).

Special thanks to [the Roots team](https://roots.io/about/) whose [Trellis](https://github.com/roots/trellis) make this project possible.

Full list of contributors can be found [here](https://github.com/TypistTech/vagrant-trellis-sequel/graphs/contributors).

## License

[Vagrant Trellis Sequel](https://github.com/TypistTech/vagrant-trellis-sequel) is released under the [MIT License](https://opensource.org/licenses/MIT).
