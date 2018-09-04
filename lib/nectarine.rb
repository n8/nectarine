require "nectarine/railtie"
require "nectarine/good_job"

module Nectarine

end

class ActiveRecord::Relation
  def nectarine(method)

    method_to_run = method.to_s

    all_jobs = []
    self.each do |item|
      all_jobs << Nectarine::GoodJob.perform_later(item, method_to_run)
    end

    Timeout::timeout(15 * 60) do 
      while(!all_job_statuses_complete?(all_jobs)) do 
        sleep 2
      end
    end

    return 
  end

  def all_job_statuses_complete?(all_jobs)
    done = all_jobs.select{|job| ActiveJob::Status.get(job).completed?}
    done.size == all_jobs.size
  end
end

