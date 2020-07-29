module Admin::CasesHelper
	def inc_in_ens(document)
		if document.included?
			return "Yes"
		else
			return "No"
		end
	end
end
