module Skittles
  class Client
    # Define methods related to campaign.
    # @see http://developer.foursquare.com/merchant/campaigns/campaigns.html
    module Campaign
      # Create a new campaign for the authenticated business
      #
      # @return [Hashie:Mash] A complete campaign.
      # @param special_id [String] Required. The ID for the special of this campaign.
      # @param group_id [Array] One or more venue group IDs.
      # @param venue_id [Array] One or more venue IDs.
      # @param start_at [DateTime] When the campaign is to be started (seconds since epoch). Cannot be older than 10 minutes into the past.
      # @param end_at [DateTime] When the campaign is to be automatically deactivated (seconds since epoch).
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/merchant/campaigns/add.html
      def add_campaign(special_id, group_id=nil, venue_id=nil, start_at=nil, end_at=nil)
        if start_at && start_at < 10.minutes.ago
          raise ArgumentError.new("start_at must be sooner than 10 minutes ago according to the Foursquare API")
        end

        group_id = [group_id] unless group_id.respond_to?(:each)
        venue_id = [venue_id] unless venue_id.respond_to?(:each)

        post("campaigns/add", {
                                 :specialId => special_id,
                                 :groupId   => group_id.join(","),
                                 :venueId   => venue_id.join(","),
                                 :startAt   => start_at,
                                 :endAt     => end_at
                              }).campaign
      end

      # Start a campaign for the authenticated business
      #
      # @return [Integer] A success code or an error message.
      # @param campaign_id [Integer] Required. The id for the campaign as returned by the Foursquare API.
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/merchant/campaigns/start.html
      def start_campaign(campaign_id)
        post("campaigns/#{campaign_id}/start")
      end

      # End a campaign for the authenticated business
      #
      # @return [Integer] A success code or an error message.
      # @param campaign_id [Integer] Required. The id for the campaign as returned by the Foursquare API.
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/merchant/campaigns/end.html
      def end_campaign(campaign_id)
        post("campaigns/#{campaign_id}/end")
      end

      # Dekete a campaign that has never been activated for the authenticated business
      #
      # @return [Integer] A success code or an error message.
      # @param campaign_id [Integer] Required. The id for the campaign as returned by the Foursquare API.
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/merchant/campaigns/delete.html
      def delete_campaign(campaign_id)
        post("campaigns/#{campaign_id}/delete")
      end

      # List campaigns for the given venues
      #
      # @param special_id [String] If specified, limits response to campaigns involving the given special.
      # @param group_id [String] If specified, limits response to campaigns involving the given group.
      # @param status [String] Which campaigns to return: pending, active, expired, all. Defaults to active.
      # @return [matches] An object with count and individual campaign items.
      # @see https://developer.foursquare.com/merchant/campaigns/list.html
      def list_campaigns(special_id=nil, group_id=nil, status=:all)
        get("campaigns/list", { :specialId => special_id, :groupId => group_id, :status => status })
      end

      # View campaign stats over a time range
      #
      # @param campaign_id [String] Required. The campaign id to retrieve stats for.
      # @param start_at [Integer] The start of the time range to retrieve stats for (seconds since epoch). If omitted, the campaign start time will be used.
      # @param end_at [Integer] The end of the time range to retrieve stats for (seconds since epoch). If omitted, the campaign end time or the current time will be used, whichever occurs first.
      # @return [timeseries] An array containing one campaign time series data object for each venue participating in the campaign.
      # @see https://developer.foursquare.com/merchant/campaigns/timeseries.html
      def timeseries_for_campaign(campaign_id, start_at=nil, end_at=nil)
        get("campaigns/#{campaign_id}/timeseries", {:startAt => start_at, :endAt => end_at }).timeseries
      end
    end
  end
end
