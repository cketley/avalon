class AddDisplayAspectRatioToMasterFile < ActiveRecord::Migration
  def up
    MasterFile.find_each({},{batch_size:5}) do |masterfile|
      if ! masterfile.display_aspect_ratio && masterfile.workflow_id 
        workflow = Rubyhorn.client.instance_xml(masterfile.workflow_id)
        if workflow && (resolutions = workflow.streaming_resolution)
          masterfile.display_aspect_ratio = resolutions.first.split(/x/).collect(&:to_f).reduce(:/).to_s 
          masterfile.save
        end
      end
    end
  end
end