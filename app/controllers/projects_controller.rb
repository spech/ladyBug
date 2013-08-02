class ProjectsController < ApplicationController

	before_filter :find_project, except: [:index, :new, :create]

	def index
		@projects = Project.all
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(project_params)
		respond_to do |format|
			if @project.save
				format.html {redirect_to @project, notice: "Project succesfully created."}
				format.json {head :no_content}
			else
				format.html {render action: 'new'}
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end

		end
	end

	def show
	end

	def edit
	end

	def update
		respond_to do |format|
		    if @project.update(project_params)
		    	format.html { redirect_to @project, notice: 'Issue was successfully updated.' }
		        format.json { head :no_content }
		    else
		        format.html { render action: 'edit' }
		        format.json { render json: @project.errors, status: :unprocessable_entity }
		    end
	    end
	end

	def destroy
		@project.destroy

		flash.notice = "Project '#{@project.title}' Deleted!"

		redirect_to projects_path 
	end

	private	
	def project_params
		params.require(:project).permit(:name, :description)
	end

	def find_project
		@project = Project.find(params[:id])
	end
end