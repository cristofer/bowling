class EnablePgcryptoExtension < ActiveRecord::Migration[5.2]
  # For UUID
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  end
end
