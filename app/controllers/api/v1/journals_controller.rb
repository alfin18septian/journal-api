class Api::V1::JournalsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :notFound

    def index
        render json: { result: true, value: Journal.all }, status: :ok
    end

    def create
        journal = Journal.create!(journal_params)
        journal_id = journal.id

        file_response = Cloudinary::Uploader.upload(params[:file], :public_id => journal_id, :folder => '/journal_files')
        if file_response
            JournalFile.create(journal_id: journal_id, url: file_response.url, format: file_response.format)
        else 
            render json: {
                message: file_response.errors,
            },
            status: :unprocessable_entity
        end
        
        category = params[:category]
        ic = 0
        
        until ic >= category.length do
            JournalCategory.create(journal_id: journal_id, category_id: category[ic])
            ic +=1
        end

        # tag = params[:tag]
        # it = 0
        
        # until it >= tag.length do
        #     JournalTag.create(journal_id: journal_id, tag_id: tag[it])
        #     it +=1
        # end

        if journal.save
            render json: {status: true, message: "Create Secces"}
        else
            render json: {result: false, massage: journal.errors}, status: :unprocessable_entity
        end
    end


    private

    def notFound
        render json: { result: false, message: "Data Not Found" }, status: :not_found
    end
    
    def journal_params
        params.require(:journal).permit(:title, :abstact, :author)
    end
    
end
