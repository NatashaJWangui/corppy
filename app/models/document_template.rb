class DocumentTemplate < ApplicationRecord
  belongs_to :business_category
  belongs_to :country
  belongs_to :state, optional: true

  has_many :documents, dependent: :restrict_with_error

  validates :template_name, presence: true
  validates :template_content, presence: true
  validates :fees, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }

  def formatted_fees
    "$#{fees}"
  end

  class << self
    def generate_template_content(category, state)
      case state.code
      when "DE"
        delaware_template(category)
      when "CA"
        california_template(category)
      when "TX"
        texas_template(category)
      when "FL"
        florida_template(category)
      when "NV"
        nevada_template(category)
      end
    end

    def calculate_state_fees(state_code)
      fees = {
        "DE" => 89.00,   # Delaware filing fee
        "CA" => 70.00,   # California filing fee
        "TX" => 300.00,  # Texas filing fee
        "FL" => 70.00,   # Florida filing fee
        "NV" => 75.00    # Nevada filing fee
      }
      fees[state_code] || 100.00
    end

    private

    def delaware_template(category)
      <<~TEMPLATE
        CERTIFICATE OF INCORPORATION
        OF
        {{business_name}}

        FIRST: The name of this Corporation is {{business_name}}.

        SECOND: Its registered office in the State of Delaware is to be located at {{registered_agent_address}}, in the City of {{registered_agent_city}}, County of {{registered_agent_county}}, Zip Code {{registered_agent_zip}}. The registered agent in charge thereof is {{registered_agent_name}}.

        THIRD: The purpose of the corporation is to engage in {{business_description}} and any lawful act or activity for which corporations may be organized under the General Corporation Law of Delaware.

        FOURTH: The total number of shares of stock which the Corporation shall have authority to issue is {{shares_authorized}} shares of Common Stock, each with a par value of $0.001 per share.

        FIFTH: The name and mailing address of the incorporator is:
        {{incorporator_name}}
        {{incorporator_address}}

        SIXTH: The powers of the incorporator shall terminate upon the filing of these Articles of Incorporation, and the name(s) of the person(s) who will serve as the initial director(s) is/are:
        {{directors}}

        IN WITNESS WHEREOF, the undersigned, being the incorporator hereinbefore named, has executed, signed and acknowledged these Articles of Incorporation this {{date}} day of {{month}}, {{year}}.

        ___________________________
        {{incorporator_signature}}
        Incorporator
      TEMPLATE
    end

    def california_template(category)
      <<~TEMPLATE
        ARTICLES OF INCORPORATION
        OF
        {{business_name}}

        TO THE SECRETARY OF STATE OF CALIFORNIA:

        The undersigned, for the purpose of forming a corporation under the laws of the State of California, executes the following Articles of Incorporation:

        ARTICLE I - NAME
        The name of this corporation is {{business_name}}.

        ARTICLE II - PURPOSE#{'  '}
        The purpose of this corporation is to engage in {{business_description}} and any lawful activity within the purposes for which corporations may be organized under the General Corporation Law of California.

        ARTICLE III - AGENT FOR SERVICE OF PROCESS
        The name and address in California of this corporation's initial agent for service of process is:
        {{agent_name}}
        {{agent_address}}

        ARTICLE IV - STOCK
        This corporation is authorized to issue only one class of shares of stock; and the total number of shares which this corporation is authorized to issue is {{shares_authorized}} shares.

        ARTICLE V - INCORPORATOR
        The name and address of the incorporator is:
        {{incorporator_name}}
        {{incorporator_address}}

        Dated: {{date}}

        ___________________________
        {{incorporator_signature}}
        Incorporator
      TEMPLATE
    end

    def texas_template(category)
      <<~TEMPLATE
        CERTIFICATE OF FORMATION
        FOR-PROFIT CORPORATION
        {{business_name}}

        Entity Information:
        The name of the entity is: {{business_name}}

        The period of duration is: Perpetual

        Purpose: The purpose for which the entity is organized is {{business_description}} and to engage in any lawful act or activity for which corporations may be organized under the Texas Business Organizations Code.

        Registered Agent and Registered Office:
        The registered agent is {{registered_agent_name}}.
        The business address of the registered agent is {{registered_agent_address}}.

        Governing Authority:
        The entity will be managed by a board of directors.

        Shares:
        The total number of shares the corporation is authorized to issue is {{shares_authorized}}.

        Organizer:
        {{organizer_name}}
        {{organizer_address}}

        Effectiveness of Document:
        This document becomes effective when the document is filed by the secretary of state.

        ___________________________
        {{organizer_signature}}
        Organizer
      TEMPLATE
    end

    def florida_template(category)
      <<~TEMPLATE
        ARTICLES OF INCORPORATION
        {{business_name}}

        Pursuant to the provisions of Florida Statutes Chapter 607, the undersigned executes the following Articles of Incorporation:

        ARTICLE I - CORPORATE NAME
        The name of the Corporation is {{business_name}}.

        ARTICLE II - PRINCIPAL OFFICE
        The principal office of the Corporation shall be located at {{principal_address}}.

        ARTICLE III - REGISTERED OFFICE AND AGENT#{'  '}
        The registered office of the Corporation is {{registered_office_address}}, and the registered agent is {{registered_agent_name}}.

        ARTICLE IV - PURPOSE
        The Corporation is organized for the purpose of {{business_description}} and engaging in any lawful act or activity for which corporations may be organized under Florida law.

        ARTICLE V - STOCK
        The Corporation shall have authority to issue {{shares_authorized}} shares of common stock, no par value.

        ARTICLE VI - INCORPORATOR
        The name and address of the incorporator is:
        {{incorporator_name}}
        {{incorporator_address}}

        ARTICLE VII - DIRECTORS
        The initial director(s) of the Corporation is/are:
        {{directors}}

        IN WITNESS WHEREOF, the incorporator has signed these Articles of Incorporation on {{date}}.

        ___________________________
        {{incorporator_signature}}
        Incorporator
      TEMPLATE
    end

    def nevada_template(category)
      <<~TEMPLATE
        ARTICLES OF INCORPORATION
        (PURSUANT TO NRS CHAPTER 78)
        {{business_name}}

        TO THE SECRETARY OF STATE OF NEVADA:

        The undersigned, acting as incorporator under Chapter 78 of the Nevada Revised Statutes, adopts the following Articles of Incorporation:

        ARTICLE 1 - NAME
        The name of the corporation is {{business_name}}.

        ARTICLE 2 - RESIDENT AGENT
        The name and address of the resident agent for service of process is:
        {{resident_agent_name}}
        {{resident_agent_address}}

        ARTICLE 3 - SHARES#{'  '}
        The corporation is authorized to issue {{shares_authorized}} shares of capital stock.

        ARTICLE 4 - PURPOSE
        The purpose of the corporation is {{business_description}} and to engage in any lawful activity within the purposes for which corporations may be organized under Nevada law.

        ARTICLE 5 - INCORPORATOR
        The name and address of the incorporator is:
        {{incorporator_name}}#{'  '}
        {{incorporator_address}}

        ARTICLE 6 - DIRECTORS
        The names and addresses of the initial directors are:
        {{directors}}

        Date: {{date}}

        ___________________________
        {{incorporator_signature}}
        Incorporator
      TEMPLATE
    end
  end
end
