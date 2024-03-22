# frozen_string_literal: true

RSpec.shared_context 'with user preferences', type: :metadata do
  fixtures :users, :projects

  include_context 'with logged user', 'jsmith'

  before do
    visit index_path
  end

  it { expect(page).to have_current_path(index_path) }

  data_combinations.each do |data|
    context "when data #{data} is submitted" do
      before do
        data.each { |key, expected| input_set_value(key, expected) }
        click_button ::I18n.t(:button_update) # rubocop:disable Capybara/ClickLinkOrButtonStyle
      end

      it { expect(page).to have_current_path(index_path) }

      data.each do |key, expected|
        it ".#{key} equal to \"#{expected}\"" do
          expect(User.current.send(user_pref_method).send(key)).to eq(expected)
        end
      end
    end
  end

  def checkbox_set_value(input_name, value)
    find_field(input_name).set(value)
  end

  def select_set_value(input_name, value)
    input = find(:select, input_name)
    found = []
    input.all(:option).each do |opt| # rubocop:disable Rails/FindEach
      found << opt[:value]
      if opt[:value] == value
        opt.select_option
        return # rubocop:disable Lint/NonLocalExitFromIterator
      end
    end
    raise "Value \"#{value}\" not found for input \"#{input_name}\" (Found: #{found})"
  end

  def input_set_value(field, value)
    send("#{input_type(field)}_set_value", "#{model_class.model_name.param_key}[#{field}]",
         value)
  end

  def input_type(field)
    send("#{field}_input_type")
  end
end
