class EventFinder

  # DEFAULT_RESULTS_PER_PAGE = 20

  attr_reader :project, :event_collection

  def initialize(project, event_collection)
    @project = project
    @event_collection = event_collection
  end

  def search()
    search = Jbuilder.encode do |json|
      json.filter do
        json.and do
          json.child! do
            json.term do
              json.project_id @project.id
            end
          end
          json.child! do
            json.term do
              json.event_collection_id @event_collection.id
            end
          end
        end
      end
    end

    p search

    MongoEvent.search(search)  

    # options ||= {}

    # @search.sort { by (options.delete(:sort_field) || :marketing_name), (options.delete(:sort_by) || :asc) }

    # per_page = if (options[:per_page] == '*' || options[:per_page] == 'all')
    #   1000000
    # else
    #   (options[:per_page] || DEFAULT_RESULTS_PER_PAGE).to_i
    # end
    # options.delete(:per_page)
    # page = (options.delete(:page) || 1).to_i

    # @search.size(per_page)
    # @search.from( page <= 1 ? 0 : (per_page * (page-1)) )
    # parse_query(options[:query]) if options[:query].present?
    # parse_facets(options[:facets]) if options[:facets].present?
    # @search.fields(options[:fields]) if options[:fields].present?
    # @search
  end

  # def filter(options={})
  #   options.each do |field, value|
  #     @search.filter :term, field => value
  #   end
  #   self
  # end

  # def results
  #   @search.results
  # end

  # protected

  # def filters
  #   if @search.filters.size > 1
  #     { :and => @search.filters.map {|filter| filter.to_hash} }
  #   else
  #     @search.filters
  #   end
  # end

  # def parse_query(filters)
  #   @search.query do
  #     boolean do
  #       filters.each do |field, values|
  #         if field.to_s == "all"
  #           must { string values }
  #         else
  #           if Array(values).size == 1
  #             must { text field, values }
  #           else
  #             must do
  #               boolean do
  #                 values.each do |value|
  #                   should { text field, value }
  #                 end
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  # def parse_facets(fields)
  #   fields.each do |field|
  #     @search.facet field, :facet_filter => @search.filters  do
  #       terms field
  #     end
  #   end
  # end

  # def index_for(scope)
  #   if scope == :my_items
  #     [ Medium.index_name, Purchase.index_name ]
  #   else
  #     [ Medium.index_name ]
  #   end
  # end
end