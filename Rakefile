require 'bundler'
require 'chromatic'

namespace :vm do

  desc 'initialize the VM'
  task :initialize do
    puts 'setting environment'.magenta
    puts '==> bundler'.magenta
    sh 'bundle'
    puts '==> librarian-puppet'.magenta
    # puts '    - clean'.magenta
    # sh 'librarian-puppet clean --verbose'
    puts '    - install'.magenta
    sh 'librarian-puppet install --verbose'
    puts '==> vagrant & provisioning'.magenta
    sh 'vagrant up'
    puts %Q|==> done - enter box via 'vagrant ssh'|.magenta
  end

  desc 'reprovision the VM (has to be running)'
  task :provision do
    puts '==> librarian-puppet'.magenta
    # puts '    - clean'.magenta
    # sh 'librarian-puppet clean --verbose'
    puts '    - install'.magenta
    sh 'librarian-puppet install'
    puts '==> provisioning'.magenta
    sh 'vagrant provision'
  end

end

namespace :puppet do

  desc 'lints the manifests'
  task :lint do
    sh 'puppet-lint --no-autoloader_layout-check manifests/site.pp'
  end

end
