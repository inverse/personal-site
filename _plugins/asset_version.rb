# Content-hash of the Sass sources that produce styles.css.
# Stable across rebuilds; changes only when styles actually change.
require 'digest'

module Jekyll
  class AssetVersionTag < Liquid::Tag
    def render(context)
      source = context.registers[:site].source
      files = [File.join(source, 'styles.scss')] +
              Dir[File.join(source, '_sass', '*.scss')].sort
      Digest::SHA256.hexdigest(files.map { |f| "#{File.basename(f)}:#{File.read(f)}" }.join)[0, 10]
    end
  end
end

Liquid::Template.register_tag('asset_version', Jekyll::AssetVersionTag)
