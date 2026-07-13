path = Dir.glob("/app/db/migrate/*add_cached_labels_list*").first
exit 0 unless path

content = File.read(path)
new_content = content.gsub(
  /ActsAsTaggableOn::Taggable::(Cache|CacheKeys)\.included\(Conversation\)/,
  "begin\n    ActsAsTaggableOn::Taggable::Cache.included(Conversation)\n  rescue NameError\n    # acts-as-taggable-on removed this module; column already added above\n  end"
)
File.write(path, new_content)
