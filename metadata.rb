name 'tomcat-cookbook'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures tomcat'
long_description 'Installs/Configures tomcat'
version '0.1.4'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'line', '~> 2.1.1'
depends 'fileutils', '~> 1.2.0'
depends 'tar', '~> 2.2.0'

depends 'delivery-truck'
# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/tomcat/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/tomcat'
