# Changelog for vagrant-openstack-plugin

## 0.4.0

- Merge pull request #49 from RackerJohnMadrid/fix-rsync-vagrant-1-4 [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/5664ead3fda8f889dad72de1de2fbb
- fixes the issue of ssh keys now being represented as an Array in vagrant >= 1.4 [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/0741d802a13c4a858
- fix regression wrt multiple nics [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/9c5441db359b34f2bbf66d30853c97b0896a494b)
- update README [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/725e66ab7970e5698aa7347dae93f791e926097a)
- implement multiple networks [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/0bbbda10bc3b6a09e3165936a2cd17d56b9d3159)
- two minor rsync bugfixes [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/5bf54e8ab99baa850631803137d991a4756f34ab)
- Merge pull request #33 from johnbellone/master [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/f863781405a1070fe991f55f93d2b37763f6c1da)
- Add actions for pausing/suspending (and inverse). [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/a5ec0edd25af250599e0e248a25d8a34af0e1c40)
- Merge pull request #31 from johnbellone/master [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/83031f79e5834693e2c45656c0ae17b6f13afe83)
- Add a little debugging output. [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/c00310ed8855d3b2b0472ab9304debefbb0918e3)
- Add travis.yml file to the project. [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/bc53baaa43c2bf652294d374e071c96bf00bcf12)
- Add proxy option to configuration. [view commit](http://github.com/cloudbau/vagrant-openstack-plugin/commit/3d33bdc9a3bf28af7403bd1a0245a9869799eadc)


## 0.3.0 (September 25, 2013)

- Adds support to determine IP address to use
- Region Support
- Enabled controlling multiple VMs in parallel
- Honor disabling of synced folders
- Adds `availability_zone` option to specify instance zone
- Added --delete to rsync command
- Call SetHostname action from Vagrant core in up phase
- Handled not having the box and providing it via a box_url.
- Allowed vagrant ssh -c 'command'
- Adds tenant to network request
- Improved documentation

## 0.2.2  (May 30, 2013)

- Also ignore HOSTUNREACH errors when first trying to connect to newly created VM

## 0.2.1 (May 29, 2013)

- Fix passing user data to server on create
- Floating IP Capability
- Added ability to configure scheduler hints
- Update doc (network config in fact has higher precedence than address_id)
- 'address_id' now defaults to 'public', to reduce number of cases in read_ssh_info
- Introduced 'address_id' config, which has a higher order of precedence than 'network'

## 0.2.0 (May 2, 2013)

- Added docs
- Removed metadata validation and bumped version
- Tenant and security groups are now configurable

## 0.1.3 (April 26, 2013)

- Added the ability to pass metadata keypairs to instances
- Added support for nics configurations to allow for selection of a specific network on creation

## 0.1.2 (April 26, 2013)

- Added the option of passing user data to VMs
- Enabled `vagrant provision` in this provider
- Made finding IP address more stable
- Doc improvements and minor fixes

## 0.1.0 (March 14, 2013)

- Initial release
