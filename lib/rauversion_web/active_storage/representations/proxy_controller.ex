# frozen_string_literal: true

# Proxy files through application. This avoids having a redirect and makes files easier to cache.
# class ActiveStorage::Representations::ProxyController < ActiveStorage::Representations::BaseController
#   include ActiveStorage::SetHeaders
#
#   def show
#     http_cache_forever public: true do
#       set_content_headers_from @representation.image
#       stream @representation
#     end
#   end
# end

defmodule RauversionExtension.UI.ActiveStorage.Representations.ProxyController do
  use RauversionExtension.UI.Web, :controller

  action_fallback RauversionExtension.UI.FallbackController

  # def show
  #   http_cache_forever public: true do
  #     set_content_headers_from @representation.image
  #     stream @representation
  #   end
  # end
end
