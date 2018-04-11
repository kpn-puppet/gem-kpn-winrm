# kpn_winrm

This gem is used to execute Puppet module acceptance tests (beaker) for Windows using WinRM instead of SSH.


TODO: rspec test for this gem

## Dependencies

This gem has two gem dependencies:
- [winrm](https://rubygems.org/gems/winrm) (version requirement: >= 2.2.2)
- [winrm-elevated](https://rubygems.org/gems/winrm-elevated) (version requirement: >= 1.1.0)

## Installation

Add this line to your spec_helper_acceptance.rb:

```ruby
require 'kpn_winrm'
```

Make sure the gem is installed:

    $ gem install kpn_winrm


## Usage

This gem contains 2 functions:
- apply_manifest_on_winrm
- winrm_command

### apply_manifest_on_winrm
This function can be used to apply a puppet manifest on the beaker node using winrm.

The functions has 3 parameters:
#### host
The host definition on which to execute the commands, for one node tests set this to `default`.

#### manifest
The ruby variable containting the manifest to apply, example:
```ruby
pp = <<-PP
      user { 'testuser':
        password => 'Dummy1234qwer!',
        groups   => ['Administrators'],
      }
    PP
```

#### opts
A hash of options, which can have one of the following:
- catch_changes
- catch_failures
- expect_failures
- expect_changes

Example
```ruby
apply_manifest_on_winrm(default, pp, :catch_failures => true)
apply_manifest_on_winrm(default, pp, :catch_changes => true)
```

### winrm_command
Run a command on the beaker node via winrm.

The functions has 3 parameters:
#### host
The host definition on which to execute the commands, for one node tests set this to `default`.

#### command
The command which should be executed via WinRM.
- acceptable_exit_codes
- run_as_cmd

#### opts
A hash of options, which can have one of the following:

Example
```ruby
winrm_command(default, 'SecEdit /export /cfg c:\cfg.txt')
```
