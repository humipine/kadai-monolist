class OwnershipsController < ApplicationController
  def create
    # find-or-initialize-by は、まず、Itemの中からfind-byして、見つかれは、
    # テーブルに保存されているインスタンスを返します。
    # 見つからなければ、Itemをnewして、新規作成します。
    @item = Item.find_or_initialize_by(code: params[:item_code])
    
    #item-persisted?は、取得したインスタンス@itemが、すでに保存されているか
    # どうかを確認します。保存されている場合 trueを返します。保存されていな
    # ければ、falseを返します。
    unless @item.persisted?
      # @itemが保存されていない場合、先に @itemを保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)
      
      @item = Item.new(read(results.first))
      @item.save
    end
    
    # Want 関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品をWantしました。'
    elsif params[:type] == 'Have'
      current_user.buy(@item)
      flash[:success] = '商品を購入しました。'
    end
    
    # Want(Have)ボタンをクリックしたページに戻る
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    @item = Item.find(params[:item_id])
    
    if params[:type] == 'Want'
      current_user.unwant(@item)
      flash[:success] = '商品の Want を解除しました。'
    elsif params[:type] == 'Have'
      current_user.delete_from_having(@item)
      flash[:success] = '商品のHaveを解除しました。'
    end
    
    # Unwant/DeleteFromHavingボタンをクリックしたページに戻る
    redirect_back(fallback_location: root_path)
  end
end