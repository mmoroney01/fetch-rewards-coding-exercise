class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_transaction, only: %i[ show edit update destroy ]

  def spendpoints
    #total of points to be spent
    points = params["points"].to_i

    #collection containing all transactions, sorted in ascending chronological order
    transactions = Transaction.all.sort_by { |log_item| log_item.timestamp }

    #this will be an array of transaction hashes that have payers/points/timestamps
    bigarray = []

    transactions.each do |t|

      date = t.timestamp.strftime("%m/%d/%Y")

      #if bigarray contains a hash that has a duplicate payer AND a duplicate timestamp
      if bigarray.any? {|h| h[:payer] == t.payer} && bigarray.any? {|h| h[:date] == date}

        #then adjust that hash's point total accordingly, instead of making a new one
        temphash = bigarray.find {|h| h[:payer] == t.payer && h[:date] == date}
        temphash[:points] = temphash[:points] + t.points

      #otherwise, create a new hash containing the payer/points/timestamp
      else 
        hash = {}
        hash[:payer] = t.payer
        hash[:points] = t.points
        hash[:date] = date

        bigarray << hash
        
      end
    end

    @hash_array_to_return = []

    bigarray.each do |h|
      if points > 0
        #if the amount of remaining points to spend is less than the payer's available points
        if points < h[:points]
          #create a hash containing the payer and the amount of points spent
          spent_hash = {}
          spent_hash[:payer] = h[:payer]
          spent_hash[:points] = points * -1
          @hash_array_to_return << spent_hash

          #and reduce points to zero, as there are no further points that can be spent
          points = 0
        end
        
        #if the points amount to be spent is greater than the payer's available points
        if points > h[:points]
          spent_hash = {}
          spent_hash[:payer] = h[:payer]
          spent_hash[:points] = h[:points] * -1
          @hash_array_to_return << spent_hash
          
          #decrease the points amount to be spent accordingly
          points = points - h[:points]
        end
      end
    end

    #to ensure that a payer's point total persists, each hash is saved as a transaction with a current timestamp
    @hash_array_to_return.each do |h|
      transaction = Transaction.new(payer: h[:payer], points: h[:points], timestamp: DateTime.now)
      transaction.save  
    end

    return @hash_array_to_return
   end

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all.sort_by { |log_item| log_item.timestamp }
    @transactions = @transactions.reverse
    @payer_points = {}

    #for each separate payer
    Transaction.distinct.pluck(:payer).each do |x|
      point_total = 0

      #get a collection of that payer's transactions
      payers_transactions = Transaction.where(:payer => x)

      #then, for each of that payer's transactions
      payers_transactions.each do |y|
        #increase that payer's point total by that transaction's point amount
        point_total += y.points
      end

      #then assign key-value pairs to the @payer-points hash, where payer is key and point total is value
      @payer_points[x] = point_total
    end
    
    return @transactions, @payer_points
   end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:payer, :points, :timestamp)
    end
end
