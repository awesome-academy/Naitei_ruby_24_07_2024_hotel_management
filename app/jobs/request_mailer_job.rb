class RequestMailerJob < ApplicationJob
  queue_as :mailers

  def perform request, email_type
    case email_type
    when :accept
      UserMailer.request_accept(request.user, request).deliver_now
    when :reject
      UserMailer.request_reject(request.user, request).deliver_now
    else
      raise ArgumentError, "Unknown email type: #{email_type}"
    end
  end
end
