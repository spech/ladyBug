class IssuesController < ApplicationController

	before_filter :find_issue, except: [:index, :new, :create]
	before_filter :define_note, only: [:show, :update]

	def index
		@project = Project.find(params[:project_id])
		@issues = @project.issues
	end	

	def new
		@issue = Issue.new
		@project = Project.find(params[:project_id])
	end

	def create
		@issue = Issue.new(issue_params)
		@project = Project.find(params[:project_id])
		@issue.project_id = @project.id
		respond_to do |format|
			if @issue.save
				format.html {redirect_to project_issue_path(@issue.project, @issue), :flash => { :success => "Issue succesfully created." } }
				format.json {head :no_content}
			else
				format.html { render action: 'new'}
				format.json { render json: @issue.errors, status: :unprocessable_entity }
			end
		end
	end

	def show
		@project = Project.find(params[:project_id])
	end

	def edit
	end

	def update
		if params[:issue][:state_event]
			if @issue.fire_state_event(params[:issue][:state_event]) 
			  respond_update_success
			else
			  respond_update_error 'show'
			end
	    else
	    if @issue.update(issue_params)
	      @issue.fire_state_event(params[:issue][:state_event]) if params[:issue][:state_event]
		    respond_update_success 
		  else
		    respond_update_error 'edit'
		  end
		end
	end

	def respond_update_success
	  respond_to do |format|
	    format.html { redirect_to project_issue_path(@issue.project, @issue), :flash => { :success => 'Issue state was successfully updated.' }}
	    format.json { head :no_content }
	  end 
	end

	def respond_update_error path
	  respond_to do |format|
	  	format.html { render action: path }
	    format.json { render json: @issue.errors, status: :unprocessable_entity }
	  end
	end

	def destroy
		@issue.notes.destroy_all
		@issue.destroy

		flash[:error]= "Issue '#{@issue.title}' Deleted!"

		redirect_to issues_path 
	end

	private
	def issue_params
		params.require(:issue).permit(:title, :description, :analysis)
	end

	def find_issue
		@issue = Issue.find(params[:id])
	end

	def define_note
		@note = Note.new
		@note.issue_id = @issue.id
	end

end
