
require 'spec_helper_acceptance'

describe 'hashlimit property' do
  before :all do
    iptables_flush_all_tables
    ip6tables_flush_all_tables
  end

  describe 'hashlimit_tests' do
    context 'hashlimit_above' do
      it 'applies' do
        pp = <<-EOS
          class { '::firewall': }
          firewall { '800 - hashlimit_above test':
            chain                       => 'INPUT',
            proto                       => 'tcp',
            hashlimit_name              => 'above',
            hashlimit_above             => '512kb/s',
            hashlimit_htable_gcinterval => '10',
            hashlimit_mode              => 'srcip,dstip',
            action                      => accept,
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => do_catch_changes)
      end

      it 'should contain the rule' do
        shell('iptables-save') do |r|
          expect(r.stdout).to match(/-A INPUT -p tcp -m hashlimit --hashlimit-above 512kb\/s --hashlimit-mode srcip,dstip --hashlimit-name above --hashlimit-htable-gcinterval 10 -m comment --comment "800 - hashlimit_above test" -j ACCEPT/)
        end
      end
    end

    context 'hashlimit_above_ip6' do
      it 'applies' do
        pp = <<-EOS
          class { '::firewall': }
          firewall { '801 - hashlimit_above test ipv6':
            chain                       => 'INPUT',
            provider                    => 'ip6tables',
            proto                       => 'tcp',
            hashlimit_name              => 'above-ip6',
            hashlimit_above             => '512kb/s',
            hashlimit_htable_gcinterval => '10',
            hashlimit_mode              => 'srcip,dstip',
            action                      => accept,
          }  
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => do_catch_changes)
      end

      it 'should contain the rule' do
        shell('ip6tables-save') do |r|
          expect(r.stdout).to match(/-A INPUT -p tcp -m hashlimit --hashlimit-above 512kb\/s --hashlimit-mode srcip,dstip --hashlimit-name above-ip6 --hashlimit-htable-gcinterval 10 -m comment --comment "801 - hashlimit_above test ipv6" -j ACCEPT/)
        end
      end
    end

    context 'hashlimit_upto' do
      it 'applies' do
        pp = <<-EOS
          class { '::firewall': }
          firewall { '802 - hashlimit_upto test':
            chain                   => 'INPUT',
            hashlimit_name          => 'upto',
            hashlimit_upto          => '16/sec',
            hashlimit_burst         => '640',
            hashlimit_htable_size   => '1310000',
            hashlimit_htable_max    => '320000',
            hashlimit_htable_expire => '36000000',
            action                  => accept,
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => do_catch_changes)
      end

      it 'should contain the rule' do
        shell('iptables-save') do |r|
          expect(r.stdout).to match(/-A INPUT -p tcp -m hashlimit --hashlimit-upto 16\/sec --hashlimit-burst 640 --hashlimit-name upto --hashlimit-htable-size 1310000 --hashlimit-htable-max 320000 --hashlimit-htable-expire 36000000 -m comment --comment "802 - hashlimit_upto test" -j ACCEPT/)
        end
      end
    end

    context 'hashlimit_upto_ip6' do
      it 'applies' do
        pp = <<-EOS
          class { '::firewall': }
          firewall { '803 - hashlimit_upto test ip6':
            chain                   => 'INPUT',
            provider                => 'ip6tables',
            hashlimit_name          => 'upto-ip6',
            hashlimit_upto          => '16/sec',
            hashlimit_burst         => '640',
            hashlimit_htable_size   => '1310000',
            hashlimit_htable_max    => '320000',
            hashlimit_htable_expire => '36000000',
            action                  => accept,
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => do_catch_changes)
      end

      it 'should contain the rule' do
        shell('ip6tables-save') do |r|
          expect(r.stdout).to match(/-A INPUT -p tcp -m hashlimit --hashlimit-upto 16\/sec --hashlimit-burst 640 --hashlimit-name upto-ip6 --hashlimit-htable-size 1310000 --hashlimit-htable-max 320000 --hashlimit-htable-expire 36000000 -m comment --comment "803 - hashlimit_upto test ip6" -j ACCEPT/)
        end
      end
    end

  end

end
