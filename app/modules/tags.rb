module Tags

  def create_tag(tag)
    Tag.where(tag: tag).first_or_create
  end
end
