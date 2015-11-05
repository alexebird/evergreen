desc 'install evergreen to the arduino'
task :install, [:ip] do |t,args|
  ip = args[:ip]
  #puts <<HERE
  system <<HERE
cd .. && \
rm -rfv evergreen.tar.gz && \
tar cvzf evergreen.tar.gz evergreen && \
scp evergreen.tar.gz root@#{ip}:~ && \
ssh root@#{ip} 'tar xzf evergreen.tar.gz && rm -v evergreen.tar.gz'
HERE
end
