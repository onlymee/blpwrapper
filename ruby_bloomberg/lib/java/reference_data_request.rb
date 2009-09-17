module RubyBloomberg
  class ReferenceDataRequest < JavaRequest
    
    def read_message_data(message)
      raise "oops, thought there was only going to be 1 element here, better rethink this!" unless message.numElements == 1
      security_data_array = message.getElement("securityData")
      
      @data_table.set_header_at_index(0, "security")
      
      0.upto(security_data_array.numValues - 1) do |i|
        security_data = security_data_array.getValueAsElement(i)
        
        security_code = security_data.getElementAsString("security")
        field_data = security_data.getElement("fieldData")
        
        row = ForgetMeNot::Row.new
        row.append security_code

        0.upto(field_data.numElements - 1) do |k|
          field = field_data.getElement(k)

          if @data_table.headers[k+1].nil?
            @data_table.set_header_at_index(k+1, field.name.to_s)
          else
            raise "field names #{field.name}, #{@data_table.headers[k+1]} do not match!" unless @data_table.headers[k+1] === field.name.to_s
          end

          row.append field_value(field)
        end

        @data_table.append(row)
      end
    end
  end
end