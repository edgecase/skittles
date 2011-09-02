module Skittles
  class Client
    # Define methods related to specials.
    # @see http://developer.foursquare.com/docs/specials/specials.html
    module Special
      # Allows users to indicate a special is improper in some way.
      #
      # @params special_id [String] The id of the special being flagged.
      # @param venue_id [String] The id of the venue running the special.
      # @param problem [String] One of not_redeemable, not_valuable, other.
      # @param options [Hash] A customizable set of options.
      # @option options [String] text Additional text about why the user has flagged this special.
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/docs/specials/flag.html
      def flag_special(special_id, venue_id, problem, options = {})
        post("specials/#{special_id}/flag", { :venueId => venue_id, :problem => problem }.merge(options))
        nil
      end
      
      # Gives details about a special, including text and unlock rules.
      #
      # @param special_id [String] Id of special to retrieve.
      # @return [Hashie::Mash] A complete special.
      # @requires_acting_user No
      # @see http://developer.foursquare.com/docs/specials/specials.html
      def special(special_id, venue_id)
        get("specials/#{special_id}", :venueId => venue_id).special
      end
      
      # Returns a list of specials near the current location.
      #
      # @note This is an experimental API.
      # @param ll [String] Latitude and longitude to search near.
      # @param options [Hash] A customizable set of options.
      # @option options [Decimal] llAcc Accuracy of latitude and longitude, in meters.
      # @option options [Decimal] alt Altitude of the user's location, in meters.
      # @option options [Decimal] altAcc Accuracy of the user's altitude, in meters.
      # @option options [Integer] limit Number of results to return, up to 50.
      # @return [Hashie::Mash] An array of specials being run at nearby venues.
      # @requires_acting_user Yes
      # @see http://developer.foursquare.com/docs/specials/search.html
      def special_search(ll, options = {})
        get('specials/search', { :ll => ll }.merge(options)).specials
      end

      # Create a new special for the authenticated business
      #
      # @return [Hashie:Mash] A complete special
      # @param name [String] Required. A name for the special.
      # @param text [String] Required. Text description for the special.
      # @param unlockedText [String] Required. Special text that is shown when the user has unlocked the special.
      # @param finePrint [String] Fine print, shown in small type on the special detail page.
      # @param type [String] Required. The type of special. Must be one of: mayor, frequency, count, regular, swarm, friends, flash.
      # @param count1 [Integer] Count for frequency, count, regular, swarm, friends, and flash specials.
      # @param options [Integer] Secondary count for regular, flash specials.
      # @param options [Integer] Tertiary count for flash specials.
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/merchant/specials/add.html
      def add_special(name, text, unlocked_text, fine_print=nil, type=:regular, count1=1, count2=nil, count3=nil)
        post("specials/add", {
                               :name         => name,
                               :text         => text,
                               :unlockedText => unlocked_text,
                               :finePrint    => fine_print,
                               :type         => type,
                               :count1       => count1,
                               :count2       => count2,
                               :count3       => count3
                            }).special
      end

      # Retire a special for the authenticated business
      #
      # @return [Integer] A success code or an error message.
      # @param special_id [Integer] Required. The id for the special as returned by the Foursquare API.
      # @require_acting_user Yes
      # @see https://developer.foursquare.com/merchant/specials/retire.html
      def retire_special(special_id)
        post("specials/#{special_id}/retire")
      end

      # List specials for the given venues
      #
      # @param venue_ids [Array] Required. One or more venue ids for which to list specials.
      # @param status [String] Which specials to return: pending, active, expired, all. Defaults to all.
      # @return [specials] An object with count and individual special items.
      # @see https://developer.foursquare.com/merchant/specials/list.html
      def list_specials(venue_ids=[], status=:all)
        venue_ids = [venue_ids] unless venue_ids.respond_to?(:each)

        get("specials/list", { :venueId => venue_ids.join(","), :status => status })
      end

      # View special configuration details related to its campaign
      #
      # @param venue_ids [Array] Required. One or more venue ids for which to list specials.
      # @param status [String] Which specials to return: pending, active, expired, all. Defaults to active.
      # @return [special] A special configuration object.
      # @see https://developer.foursquare.com/merchant/specials/list.html
      def configuration_for_special(special_id)
        get("specials/#{special_id}").special
      end
    end
  end
end
