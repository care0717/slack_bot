
class ReceiptService
  def initialize
    @dao = ReceiptDao.new
  end
  def analyze(data)
    file_mimetype = data['file']['mimetype']
    file_id = data['file']['id']
    if file_mimetype&.include?("image")
      recipt = @dao.parse(file_id)
    end
    return recipt
  end
end
