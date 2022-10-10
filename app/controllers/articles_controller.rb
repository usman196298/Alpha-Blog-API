class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    #before_action :require_user, except: [:show, :index]
    #before_action :require_same_user, only: [:edit, :update, :destroy]


    def show
        render json:{article:@article,cat:@article.categories}
    end

    def index 
        #@articles = Article.paginate(page: params[:page], per_page: 5)
        @articles = Article.all
        #For Postman check
        render json: @articles, status: 200
    end

    def new
        @article =  Article.new
    end

    def edit
        render json: @article.categories
    end

    def create 
        # byebug
        @article = Article.new (article_params)
        # @article = Article.new (permitted_params)
        #Below, I have changed the code by assigning it to User.first
        # @article.user = current_user

        #Below line is for API
        @article.user = current_user

        if @article.save
            render json: @article, status: :created
            flash[:notice] = "Article was created successfully !"
            #redirect_to @article
        else
            render json: @article.errors, status: :unprocessable_entity
            #render 'new'
        end
    end

    def update 
        if @article.update(article_params)
            #flash[:notice] = "Article was updated successfully !"
            #render json: @article, status: 200
            render json: { message: "Updated successfully"}
            #redirect_to @article
        else
            render json: {error:"not created"},status: :unprocessable_entity
        end
    end

    def destroy
        @article.destroy
    end


    #Applying 'Don't Repeat Yourself Approach (DRY)'

    private
    # do not put end after private as it is not a class and we don't need end for it. Also, it should be at the bottom of the code

    def set_article
       # @article = Article.find(params[:id])
        if ( Article.find_by_id(params[:id]) )
            @article = Article.find(params[:id])
            # render json: @article
        else
            render json: { error: "Id not exists" }
        end
    end

    def article_params
        #params.require(:article).permit(:title, :description, category_ids: [])
        params.permit(:title, :description, :category_ids)
    end

    def require_same_user
        if current_user != @article.user && !current_user.admin?
            flash[:alert] = "You can only edit or delete your own article"
            render json: { message: "You can only edit or delete your own article" }
            #redirect_to @article
        end
    end

end