#coding: utf-8

require 'spec_helper'

describe Cast do
  subject { create(:cast) }
  
  it { should validate_presence_of(:title).with_message("标题不能为空") }
  it { should ensure_length_of(:title).is_at_most(32).with_long_message("标题最长为32字符") }

end
