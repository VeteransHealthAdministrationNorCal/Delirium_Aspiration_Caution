select distinct
	t.PatientSSN,
	t.PatientFirstName,
	t.PatientLastName,
	t.AdmitDateTime,
	t.OrderableItemName
from(
	select
		patient.PatientSSN,
		patient.PatientFirstName,
		patient.PatientLastName,
		inpat.AdmitDateTime,
		inpat.DischargeDateTime,
		orderitem.OrderableItemName,
		cprsorder.EnteredDateTime,
		cprsorder.OrderStopDateTime
	from
		LSV.BISL_R1VX.AR3Y_Inpat_Inpatient as inpat
		inner join LSV.CPRSOrder.CPRSOrder as cprsorder
			on cprsorder.PatientSID = inpat.PatientSID
		inner join LSV.CPRSOrder.OrderedItem as cprsorderitem
			on cprsorderitem.PatientSID = inpat.PatientSID  
		inner join LSV.Dim.OrderableItem as orderitem
			on orderitem.OrderableItemSID = cprsorderitem.OrderableItemSID  
		inner join LSV.BISL_R1VX.AR3Y_SPatient_SPatient as patient
			on inpat.PatientSID = patient.PatientSID
	where
		inpat.Sta3n = '612'
		and inpat.DischargeDateTime is null
		and inpat.AdmitDateTime >= convert(Datetime2(0), dateadd(day, -3, getdate()))
		and (
			orderitem.OrderableItemName like '%Delirium Precautions%' 
			or orderitem.orderableItemName like '%ASPIRATION PRECAUTIONS%'
		)
		and cprsorder.EnteredDateTime >= convert(datetime2(0), inpat.AdmitDateTime)
		
		) as t
order by
	t.PatientSSN