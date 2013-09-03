#
# Cookbook Name:: cache-warmer
# Provider:: image
#
# 2013 Abel Lopez (alop@att.com)

include Chef::Mixin::ShellOut

action :prefetch do
  @user = new_resource.identity_user
  @pass = new_resource.identity_pass
  @tenant = new_resource.identity_tenant
  @ks_uri = new_resource.identity_uri

  name = new_resource.image_name
  id = determine_image_id(name)
  prefetch_image(id)
  new_resource.updated_by_last_action(true)
end

private
def determine_image_id(name)
  glance_cmd = "glance --insecure -I #{@user} -K #{@pass} -T #{@tenant} -N #{@ks_uri}"

    p = shell_out("#{glance_cmd} image-show #{name} | grep id | awk '{print $4}'")
    image_id = p.stdout
    return image_id
end

private
def prefetch_image(id)
  glance_cmd = "glance --insecure -I #{@user} -K #{@pass} -T #{@tenant} -N #{@ks_uri}"

  execute "Prefetching image #{id}" do
    cwd "/tmp"
    command "#{glance_cmd} image-download #{id} > /dev/null"
    not_if { File.exists?("/var/lib/glance/image-cache/incomplete/#{id}") or File.exists?("/var/lib/glance/image-cache/#{id}") }
  end
end

