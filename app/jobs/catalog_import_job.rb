# frozen_string_literal: true

class CatalogImportJob < ApplicationJob
  sidekiq_options queue: :priority

  def perform
    response = http_client.get catalog_url
    raise "Failed to fetch catalog, response status was #{response.status}" unless response.status == 200

    catalog_data = JSON.parse response.body
    CatalogImport.perform catalog_data

    CategoryRankingJob.perform_async
  end

  def catalog_url
    Rails.configuration.catalog_url
  end

  def http_client
    @http_client ||= HttpService.client
  end
end
