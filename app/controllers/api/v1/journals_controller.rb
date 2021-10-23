class Api::V1::JournalsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :notFound

    def index
        render json: { result: true, value: custom_journals_data(Journal.all) }, status: :ok
    end

    def create
        file_response = Cloudinary::Uploader.upload(params[:file], :public_id => generate_token, :folder => '/journal_files')
        if file_response
            upload = Upload.create!(url: file_response['url'], tipe: file_response['format'])
            if upload.save
                journal = Journal.create!(journal_params.merge(upload_id: upload.id))
                
                journal_id = journal.id
                
                category = params[:category]
                ic = 0
                until ic >= category.length do
                    JournalCategory.create(journal_id: journal_id, category_id: category[ic])
                    ic +=1
                end
                if journal.save
                    
                    render json: {status: true, message: "Create Secces"}
                else
                    render json: {result: false, massage: journal.errors}, status: :unprocessable_entity
                end
            else 
                # unlink Berkas
                render json: {
                    message: upload.errors,
                },
                status: :unprocessable_entity
            end
        else 
            render json: {
                message: file_response.errors,
            },
            status: :unprocessable_entity
        end
    end

    private

    def notFound
        render json: { result: false, message: "Data Not Found" }, status: :not_found
    end
    
    def journal_params
        params.permit(:title, :abstact, :author)
    end

    def custom_journals_data(journals)
        journals.map do |journal|
            journal_categories = JournalCategory.where(journal_id: journal.id)
            {
                id: journal.id,
                title: journal.title,
                abstract: journal.abstact,
                author: journal.author,
                upload_url: journal.upload.url,
                categories: journal_categories.map do |journal_category|
                    {
                        category: journal_category.category.category,
                    }
                end
            }
        end
    end

    def generate_token
        SecureRandom.hex(10)
    end
    
end
