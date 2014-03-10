class MongoEventsController < ApplicationController
  # GET /mongo_events
  # GET /mongo_events.json
  def index
    @mongo_events = MongoEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mongo_events }
    end
  end

  # GET /mongo_events/1
  # GET /mongo_events/1.json
  def show
    @mongo_event = MongoEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mongo_event }
    end
  end

  # GET /mongo_events/new
  # GET /mongo_events/new.json
  def new
    @mongo_event = MongoEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mongo_event }
    end
  end

  # GET /mongo_events/1/edit
  def edit
    @mongo_event = MongoEvent.find(params[:id])
  end

  # POST /mongo_events
  # POST /mongo_events.json
  def create
    @mongo_event = MongoEvent.new(params[:mongo_event])

    respond_to do |format|
      if @mongo_event.save
        format.html { redirect_to @mongo_event, notice: 'Mongo event was successfully created.' }
        format.json { render json: @mongo_event, status: :created, location: @mongo_event }
      else
        format.html { render action: "new" }
        format.json { render json: @mongo_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mongo_events/1
  # PUT /mongo_events/1.json
  def update
    @mongo_event = MongoEvent.find(params[:id])

    respond_to do |format|
      if @mongo_event.update_attributes(params[:mongo_event])
        format.html { redirect_to @mongo_event, notice: 'Mongo event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mongo_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mongo_events/1
  # DELETE /mongo_events/1.json
  def destroy
    @mongo_event = MongoEvent.find(params[:id])
    @mongo_event.destroy

    respond_to do |format|
      format.html { redirect_to mongo_events_url }
      format.json { head :no_content }
    end
  end
end
