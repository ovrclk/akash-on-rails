require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/s3'

s3_options = {
  bucket: ENV['FILEBASE_BUCKET'],
  endpoint: ENV['FILEBASE_URL'] || 'https://s3.filebase.com',
  region: 'us-east-1',
  access_key_id: ENV['FILEBASE_KEY'],
  secret_access_key: ENV['FILEBASE_SECRET']
}

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
  # cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(prefix: 'uploads', **s3_options)
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :pretty_location
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :remote_url, max_size: 20*1024*1024
