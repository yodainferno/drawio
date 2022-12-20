# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Canva, type: :model do
  # тестируем валидации
  describe 'validations' do
	
    # тестируем валидации, когда нет name
    context 'when name not exist' do
      it { should_not allow_value(nil).for(:name) }
    end

    context 'when name not exist' do
      it { should_not allow_value(nil).for(:data) }
    end

	  context 'when all right' do
	    it { should allow_value('NONAME').for(:id) }
	    it { should allow_value('[]').for(:data) }
	  end
  end


  describe 'paint' do
    let(:id) { 0 }
    result_null = {
      id: 0,
      name: 'NONAME',
      active: true,
      private_doc: true,
      is_it_my: true,
      creator: nil,
      data: '[]',
      opened: false
    }

    subject { described_class.new({id: id}) }

    context 'when id = 0' do

      it 'should sum values' do
        expect(subject[:id]).to eq(result_null[:id])
        expect(subject[:active]).to eq(result_null[:active])
      end
    end

  end
end