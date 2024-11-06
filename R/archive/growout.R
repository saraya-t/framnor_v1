# library(memisc)
# library(dplyr)
# library(googlesheets)
# library(googledrive)
# library(googleformr)
# library(data.table)
# library(tidyr)
# library(googlesheets4)
# library(readxl)
# 
# # Ongrowing
# 
# data<-read_excel("Copy of Norsk_Farm questionnaire survey_15.07.2021_for testing (Responses) (1).xlsx")
# grow<-filter(data, data$`2.6` =="Produksjon av matfisk") 
# 
# #1) LOCATION OF THE FARM
# 
# #1- full presence of biosecurity measure/ total absence of risk
# #0- total absence of biosecurity measure/ full presence of risk
# 
# #Hvor er lokaliteten plassert?
# q0<-ifelse(grow$`2.9`=="På land",1,0)
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Settefiskanlegg]
# q1<-ifelse(grow$`2.10.1`=="Ingen",1,0)
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Postsmolt]
# q2<-ifelse(grow$`2.10.2` =="Ingen",1,0)     
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Matfisk]
# q3<-ifelse(grow$`2.10.3` =="Ingen",1,0)
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Slakteri og/eller videreforedlingsbedrift]
# q4<-ifelse(grow$`2.10.4` =="Ingen",1,0)
# #Finnes det gjerder, porter eller skilt som advarer personer og kjøretøy mot adgang til anlegget uten tillatelse?
# q5<-ifelse(grow$`8.8000000000000007`=="Ja",1,ifelse(grow$`8.8000000000000007`=="Ikke aktuelt, da lokaliteten ikke er på land",1,0))
# 
# #weight of the questions
# w0<-1
# w1<-1
# w2<-1
# w3<-1
# w4<-1
# w5<-1
#   
#   
# sub1<-rowSums(cbind(q0*w0,q1*w1,q2*w2,q3*w3,q4*w4,q5*w5), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 6)
# su1.1<-(sub1/6)*100
# su1.1
# 
# #mean of the scores for this subcategory
# msu1.1<-mean(su1.1)
# msu1.1
# 
# summary(su1.1)
# 
# #2) Introduction of live fish
# #Er det egen protokol (SOP) for inntak av fisk?
# q6<-ifelse(grow$`5.0999999999999996`=="Ja",1,0)
# #Hvor mange forsendelser med smolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder?-Fra eget selskap
# q7<-ifelse(grow$`5.2.1`=="Ingen",1,0)
# #Hvor mange forsendelser med smolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder?-Fra ekternt selskap
# q8<-ifelse(grow$`5.2.2`=="Ingen",1,0)
# #Hvor mange forsendelser med postsmolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder? Fra eget selskap
# q9<-ifelse(grow$`5.3.1`=="Ingen",1,0)
# #Hvor mange forsendelser med postsmolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder?Fra ekternt selskap
# q10<-ifelse(grow$`5.3.2`=="Ingen",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi krever helseattest/rapporter som dokumenterer fravær av viktige smittsomme agens i settefiskpopulasjonen
# q11<-ifelse(grow$`5.4.1`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi krever resultater fra diagnostiske undersøkelser som gjelder viktige smittsomme agens
# q12<-ifelse(grow$`5.4.2`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi krever oversikt over gjennomførte smittereduserende tiltak
# q13<-ifelse(grow$`5.4.3`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi undersøker fisk ved ankomst
# q14<-ifelse(grow$`5.4.4`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi undersøker fisk og opprinnelsesanlegg før bestilling
# q15<-ifelse(grow$`5.4.5`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi krever helseattest/rapporter som dokumenterer fravær av viktige smittsomme agens i settefiskpopulasjonen
# q16<-ifelse(grow$`5.5.1`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi krever resultater fra diagnostiske undersøkelser som gjelder viktige smittsomme agens
# q17<-ifelse(grow$`5.5.2`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi krever oversikt over gjennomførte smittereduserende tiltak
# q18<-ifelse(grow$`5.5.3`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi undersøker fisk ved ankomst
# q19<-ifelse(grow$`5.5.4`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi undersøker fisk og opprinnelsesanlegg før bestilling
# q20<-ifelse(grow$`5.5.5`=="Ja",1,0)
# #Skjer lossing av fisk i et eget område og / eller i avstand fra eksisterende fisk på lokaliteten?
# q21<-ifelse(grow$`5.6`=="Ja",1,0)
# #Kreves det at fisk som leveres til lokaliteten, skal settes i karantene ved ankomst?
# q22<-ifelse(grow$`5.7`=="Ja",1,0)
# #Har anlegget egne områder/innredninger som brukes til karantene?
# q23<-ifelse(grow$`5.8`=="Ja",1,0)
# #Gjennomføres nedvask av karanteneområdene etter hver gang de har vært i bruk?
# q24<-ifelse(grow$`5.9`=="Ja",1,0)
# #Inkluderes ny fisk i fiskegrupper som er i anlegget fra før (dvs. i samme not sjøanlegg eller samme avdeling, settefiskanlegg) i løpet av en produksjonssyklus
# q25<-ifelse(grow$`8.9`=="Ja",1,0)
# 
# #weight of the questions
# w6<-1
# w7<-1
# w8<-1
# w9<-1
# w10<-1
# w11<-1
# w12<-1
# w13<-1
# w14<-1
# w15<-1
# w16<-1
# w17<-1
# w18<-1
# w19<-1
# w20<-1
# w21<-1
# w22<-1
# w23<-1
# w24<-1
# w25<-1
# 
# 
# 
# 
# sub2<-rowSums(cbind(q6*w6,q7*w7,q8*w8,q9*w9,q10*w10,q11*w11,q12*w12,q13*w13,q14*w14,q15*w15,q16*w16,q17*w17,q18*w18,q19*w19,q20*w20,q21*w21,q22*w22,q23*w23,q24*w24,q25*w25), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 20)
# su1.2<-(sub2/20)*100
# su1.2
# 
# #mean of the scores for this subcategory
# msu1.2<-mean(su1.2)
# msu1.2
# 
# summary(su1.2)
# 
# 
# #3) FEED SUPPLY
# 
# #Benyttes frosset fisk, fiskeavfall eller annet rått fôr?
# q26<-ifelse(grow$`7.6`=="Nei",1,0)
# #Hvor ofte undersøkes frosset fisk, fiskeavfall eller levende fôr, for forekomst av patogener (feks bakterier og/eller virus)?
# q27<-ifelse(grow$`7.7`=="Alle nye batcher",1, ifelse(grow$`7.7`=="Ikke aktuelt",1,0))
# 
# #weight of the questions
# w26<-1
# w27<-1
# 
# sub3<-rowSums(cbind(q26*w26,q27*w27), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 2)
# su1.3<-(sub3/2)*100
# su1.3
# 
# #mean of the scores for this subcategory
# msu1.3<-mean(su1.3)
# msu1.3
# 
# summary(su1.3)
# 
# 
# 
# #4) BIOVECTORS
# 
# #Er det satt i verk tiltak for å forhindre at predatorer og/eller åtseletere kommer inn på denne lokaliteten?
# q28<-ifelse(grow$`10.1`=="Ja",1,0)
# #Holdes fiskeavfall (eksempelvis død fisk, slaktet fisk, rester av fisk uegnet til menneskemat) unna predatorer/åtseletere?
# q29<-ifelse(grow$`10.199999999999999`=="Ja",1,0)
# #Holdes det oversikt over følgende:Tiltak som er satt i verk for å hindre predatorer
# q30<-ifelse(grow$`10.3.1`=="Ja",1,0)
# #Holdes det oversikt over følgende:Inspeksjoner av kontrolltiltak for å hindre predatorer
# q31<-ifelse(grow$`10.3.2`=="Ja",1,0)
# #Holdes det oversikt over følgende:Synsobservasjoner av relevante predatorer
# q32<-ifelse(grow$`10.3.3`=="Ja",1,0)
# #Holdes det oversikt over følgende:Tap på grunn av predatorer
# q33<-ifelse(grow$`10.3.4`=="Ja",1,0)
# 
# #weight of the questions
# w28<-1
# w29<-1
# w30<-1
# w31<-1
# w32<-1
# w33<-1
# 
# sub4<-rowSums(cbind(q28*w28,q29*w29,q30*w30,q31*w31,q32*w32,q33*w33), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 6)
# su1.4<-(sub4/6)*100
# su1.4
# 
# #mean of the scores for this subcategory
# msu1.4<-mean(su1.4)
# msu1.4
# 
# summary(su1.4)
# 
# 
# 
# #5) PERSONNEL AND VISITORS
# 
# #Hvis et eksternt transportkjøretøy (bil, båt, etc.) benyttes, kan transportpersonalet bevege seg fritt på lokaliteten mens transporten pågår?
# q34<-ifelse(grow$`9.1199999999999992`=="Nei",1,ifelse(grow$`9.1199999999999992`=="Ikke aktuelt, fordi det ikke transporteres fisk til og fra denne lokaliteten",1,0))
# #Besøker noen av medarbeiderne på denne lokaliteten andre lokaliteter regelmessig?
# q35<-ifelse(grow$`11.1`=="Nei",1,0)
# #Har personalet på lokaliteten tilgang til desinfeksjonsstasjoner?
# q36<-ifelse(grow$`11.2`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved hovedinngangen(e)
# q37<-ifelse(grow$`11.3.1`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved hovedutgangen(e)
# q38<-ifelse(grow$`11.3.2`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved inngang til områder der fisk produseres
# q39<-ifelse(grow$`11.3.3`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved utgang fra områder der fisk produseres
# q40<-ifelse(grow$`11.3.4`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Det finnes ingen desinfeksjons-stasjoner
# q41<-ifelse(grow$`11.3.5`=="Nei",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene?
# q42<-ifelse(grow$`11.4.1`=="Ja",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene?
# q43<-ifelse(grow$`11.4.2`=="Ja",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene?
# q44<-ifelse(grow$`11.4.3`=="Ja",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene? Removed
# 
# #Adgangskontroll: Kreves det at besøkende må melde fra til anleggets personale ved ankomst?
# q46<-ifelse(grow$`12.1`=="Ja",1,ifelse(grow$`12.1`=="Besøkende har ikke adgang",1,0))
# #Kreves det at besøkende følger anleggets biosikkerhets-krav?
# q47<-ifelse(grow$`12.2`=="Ja",1,ifelse(grow$`12.2`=="Besøkende har ikke adgang",1,0))
# #Er besøkende og trafikken på anlegget begrenset til det som er nødvendig for å opprettholde driften?
# q48<-ifelse(grow$`12.3`=="Ja",1,ifelse(grow$`12.3`=="Besøkende har ikke adgang",1,0))
# #Oppholder gjester seg alltid sammen med personalet på lokaliteten, mens de er på besøk?
# q49<-ifelse(grow$`12.4`=="Ja",1,ifelse(grow$`12.4`=="Besøkende har ikke adgang",1,0))
# #Er det et krav at besøkende må være i selskap med anleggets personale, for å kunne oppholde seg i produksjonsområder?
# q50<-ifelse(grow$`12.5`=="Ja",1,ifelse(grow$`12.5`=="Besøkende har ikke adgang",1,0))
# #Er det forbudt for besøkende å være i nærkontakt med, eller håndtere fisk (med mindre det er nødvendig for fiskens helse)?
# q51<-ifelse(grow$`12.6`=="Ja",1,ifelse(grow$`12.6`=="Besøkende har ikke adgang",1,0))
# #Må besøkende ha på seg beskyttelses-bekledning (feks overall/kjeledress, forkle, støvler)?
# q52<-ifelse(grow$`12.7`=="Ja",1,ifelse(grow$`12.7`=="Besøkende har ikke adgang",1,0))
# #Må besøkende signere dokumentasjon som bekrefter at de ikke har besøkt andre oppdrettslokaliteter i forkant av besøket på anlegget, eller alternativt oppgi detaljer knyttet til alle tidligere besøk?
# q53<-ifelse(grow$`12.8`=="Ja",1,ifelse(grow$`12.8`=="Besøkende har ikke adgang",1,0))
# 
# #weight of the questions
# w34<-1
# w35<-1
# w36<-1
# w37<-1
# w38<-1
# w39<-1
# w40<-1
# w41<-1
# w42<-1
# w43<-1
# w44<-1
# w45<-#Removed
# w46<-1
# w47<-1
# w48<-1 
# w49<-1
# w50<-1
# w51<-1
# w52<-1 
# w53<-1
#   
# sub5<-rowSums(cbind(q34*w34,q35*w35,q36*w36,q37*w37,q38*w38,q39*w39,q40*w40,q41*w41,q42*w42,q43*w43,q44*w44,q46*w46,q47*w47,q48*w48,q49*w49,q50*w50,q51*w51,q52*w52,q53*w53), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 19)
# su1.5<-(sub5/19)*100
# su1.5
# 
# #mean of the scores for this subcategory
# msu1.5<-mean(su1.5)
# msu1.5
# 
# summary(su1.5)
# 
# #6) USE OF DIVERS
# 
# #Hvor ofte benyttes dykkere på dette lokalitet?
# q54<-ifelse(grow$`13.1`=="Vi benytter ikke dykkere",1,0)
# #Benytter lokaliteten egne dykkere, som bare benyttes på denne lokaliteten?
# q55<-ifelse(grow$`13.2`=="Ja",1,ifelse(grow$`13.2`=="Vi benytter ikke dykkere",1,0))
# #Hvis dykkere også dykker på andre lokaliteter, benytter de utstyr som kun brukes på denne lokaliteten?
# q56<-ifelse(grow$`13.3`=="Ja",1,ifelse(grow$`13.3`=="Vi benytter ikke dykkere",1,0))
# #Hvis dykkere også dykker på andre lokaliteter, blir det krevet og kontrollert at utstyret deres er vasket og desinfisert?
# q57<-ifelse(grow$`13.4`=="Ja",1,ifelse(grow$`13.4`=="Vi benytter ikke dykkere",1,0))
# #Har anlegget desinfeksjons-prosedyrer for dykkeutstyr?
# q58<-ifelse(grow$`13.5`=="Ja",1,ifelse(grow$`13.5`=="Vi benytter ikke dykkere",1,0))
# 
# #weight of the questions
# w54<-1
# w55<-1
# w56<-1
# w57<-1
# w58<-1
# 
# sub6<-rowSums(cbind(q54*w54,q55*w55,q56*w56,q57*w57,q58*w58), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 5)
# su1.6<-(sub6/5)*100
# su1.6
# 
# #mean of the scores for this subcategory
# msu1.6<-mean(su1.6)
# msu1.6
# 
# summary(su1.6)
# 
# #7) EQUIPMENT AND VEHICLES FOR TRANSPORT OF LIVE FISH, FEED AND WASTE
# 
# #Hvor ofte i gjennomsnitt kommer det transportfartøy til denne lokaliteten i produksjonseyklusen?
# q59<-ifelse(grow$`2.11.1`=="Månedlig",0.5,ifelse(grow$`2.11.1`=="Aldri",1,0))
# #Hvor ofte i gjennomsnitt kommer det transportfartøy til denne lokaliteten i produksjonseyklusen?
# q60<-ifelse(grow$`2.11.2`=="Månedlig",0.5,ifelse(grow$`2.11.2`=="Aldri",1,0))
# #Hvor ofte i gjennomsnitt kommer det transportfartøy til denne lokaliteten i produksjonseyklusen?
# q61<-ifelse(grow$`2.11.3`=="Månedlig",0.5,ifelse(grow$`2.11.3`=="Aldri",1,0))
# #Brukes samme innredning og utstyr både til ny fisk og fisk som er i anlegget fra før?
# q62<-ifelse(grow$`5.10`=="Nei",1,0)
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Nøter
# q63<-ifelse(grow$`9.1.1`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.1`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.1`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Håver
# q64<-ifelse(grow$`9.1.2`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.2`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.2`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Sorteringsutstyr
# q65<-ifelse(grow$`9.1.3`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.3`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.3`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Pumper
# q66<-ifelse(grow$`9.1.4`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.4`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.4`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Vaksinasjonsutstyr
# q67<-ifelse(grow$`9.1.5`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.5`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.5`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Presenninger
# q68<-ifelse(grow$`9.1.6`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.6`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.6`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Lastebil
# q69<-ifelse(grow$`9.1.7`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.7`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.7`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Brønnbåt
# q70<-ifelse(grow$`9.1.8`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.8`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.8`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Fòringsutstyr
# q71<-ifelse(grow$`9.1.9`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.9`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.9`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Flytende utstyr som båter, raftingbåter ol
# q72<-ifelse(grow$`9.1.10`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(grow$`9.1.10`=="Ikke benyttet på denne lokaliteten",1,ifelse(grow$`9.1.10`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Blir utstyr som benyttes felles, vasket og desinfisert før det benyttes på ANDRE lokaliteter/avdelinger?
# q73<-ifelse(grow$`9.1999999999999993`=="Ja",1,ifelse(grow$`9.1999999999999993`=="Vi har ikke felles bruk med andre lokaliteter",1,0))
# #Blir transportkjøretøy (bil, båt, etc.) kontrollert ved ankomst?
# q74<-ifelse(grow$`9.8000000000000007`=="Ja",1,0)
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Fisk
# q75<-ifelse(grow$`9.9.2`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(grow$`9.9.2`=="Ikke aktuelt",1,ifelse(grow$`9.9.2`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Fôr
# q76<-ifelse(grow$`9.9.3`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(grow$`9.9.3`=="Ikke aktuelt",1,ifelse(grow$`9.9.3`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Avfall
# q77<-ifelse(grow$`9.9.4`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(grow$`9.9.4`=="Ikke aktuelt",1,ifelse(grow$`9.9.4`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Fisk
# q78<-ifelse(grow$`9.10.2`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(grow$`9.10.2`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(grow$`9.10.2`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Fòr
# q79<-ifelse(grow$`9.10.3`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(grow$`9.10.3`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(grow$`9.10.3`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Avfall
# q80<-ifelse(grow$`9.10.4`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(grow$`9.10.4`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(grow$`9.10.4`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q81<-ifelse(grow$`9.11.1`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q82<-ifelse(grow$`9.11.2`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q83<-ifelse(grow$`9.11.3`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q84<-ifelse(grow$`9.11.4`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q85<-ifelse(grow$`9.11.5`=="Ja",1,0)
# #Er tomme transportkjøretøy (bil, båt, etc.) desinfisert (inni og utenpå) når de forlater lokaliteten?
# q86<-ifelse(grow$`9.1300000000000008`=="Ja",1,ifelse(grow$`9.1300000000000008`=="Ikke aktuelt, fordi det ikke transporteres fisk til og fra denne lokaliteten",1,0))
# #Mottar lokaliteten død fisk fra andre anlegg/lokaliteter?
# q87<-ifelse(grow$`14.3`=="Nei",1,0)
# #Leverer lokaliteten død fisk til andre anlegg/lokaliteter?
# q88<-ifelse(grow$`14.4`=="Nei",1,0)
# #Benytter lokaliteten eksterne selskap for henting av død fisk?
# q89<-ifelse(grow$`14.5`=="Nei",1,0)
# 
# 
# #weight of the questions
# w59<-1
# w60<-1
# w61<-1
# w62<-1
# w63<-1
# w64<-1
# w65<-1
# w66<-1
# w67<-1
# w68<-1
# w69<-1
# w70<-1
# w71<-1
# w72<-1
# w73<-1
# w74<-1
# w75<-1
# w76<-1
# w77<-1
# w78<-1
# w79<-1
# w80<-1
# w81<-1
# w82<-1
# w83<-1
# w84<-1
# w85<-1
# w86<-1
# w87<-1
# w88<-1
# w89<-1 
# 
# sub7<-rowSums(cbind(q59*w59,q60*w60,q61*w61,q62*w62,q63*w63,q64*w64,q65*w65,q66*w66,q67*w67,q68*w68,q69*w69,q70*w70,q71*w71,q72*w72,q73*w73,q74*w74,q75*w75,q76*w76,q77*w77,q78*w78,q79*w79,q80*w80,q81*w81,q82*w82,q83*w83,q84*w84,q85*w85,q86*w86,q87*w87,q88*w88,q89*w89), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 31)
# su1.7<-(sub7/31)*100
# su1.7
# 
# #mean of the scores for this subcategory
# msu1.7<-mean(su1.7)
# msu1.7
# 
# summary(su1.7) 
# 
# 
# 
# #INTERNAL BIOSECURITY
# 
# #8) VACCINATION
# 
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? IPN
# q90<-ifelse(grow$`6.1.1`=="Ikke aktuell",1,ifelse(grow$`6.1.1`=="Liten betydning",0.5,ifelse(grow$`6.1.1`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? PD
# q91<-ifelse(grow$`6.1.2`=="Ikke aktuell",1,ifelse(grow$`6.1.2`=="Liten betydning",0.5,ifelse(grow$`6.1.2`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? ISA
# q92<-ifelse(grow$`6.1.3`=="Ikke aktuell",1,ifelse(grow$`6.1.3`=="Liten betydning",0.5,ifelse(grow$`6.1.3`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? VIBRIOSE
# q93<-ifelse(grow$`6.1.4`=="Ikke aktuell",1,ifelse(grow$`6.1.4`=="Liten betydning",0.5,ifelse(grow$`6.1.4`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? FURUNKULOSE
# q94<-ifelse(grow$`6.1.5`=="Ikke aktuell",1,ifelse(grow$`6.1.5`=="Liten betydning",0.5,ifelse(grow$`6.1.5`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Vintersår
# q95<-ifelse(grow$`6.1.6`=="Ikke aktuell",1,ifelse(grow$`6.1.6`=="Liten betydning",0.5,ifelse(grow$`6.1.6`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Kaldtvannsvibriose
# q96<-ifelse(grow$`6.1.7`=="Ikke aktuell",1,ifelse(grow$`6.1.7`=="Liten betydning",0.5,ifelse(grow$`6.1.7`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Yersiniose
# q97<-ifelse(grow$`6.1.8`=="Ikke aktuell",1,ifelse(grow$`6.1.8`=="Liten betydning",0.5,ifelse(grow$`6.1.8`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Flavobakteriose
# q98<-ifelse(grow$`6.1.9`=="Ikke aktuell",1,ifelse(grow$`6.1.9`=="Liten betydning",0.5,ifelse(grow$`6.1.9`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Pasteurellose
# q99<-ifelse(grow$`6.1.10`=="Ikke aktuell",1,ifelse(grow$`6.1.10`=="Liten betydning",0.5,ifelse(grow$`6.1.10`=="Moderat betydning",0.5,0)))
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? IPN
# q100<-ifelse(grow$`6.2.1`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? PD
# q101<-ifelse(grow$`6.2.2`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? ISA
# q102<-ifelse(grow$`6.2.3`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? VIBRIOSE
# q103<-ifelse(grow$`6.2.4`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? FURUNKULOSE
# q104<-ifelse(grow$`6.2.5`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? VINTERSAR
# q105<-ifelse(grow$`6.2.6`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Kaldtvannsvibriose
# q106<-ifelse(grow$`6.2.7`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Yersiniose
# q107<-ifelse(grow$`6.2.8`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Flavobakteriose
# q108<-ifelse(grow$`6.2.9`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Pasteurellose
# q109<-ifelse(grow$`6.2.10`=="Ja",1,0)
# #Hvordan utføres vaksinering av fisk på denne lokaliteten?
# q110<-ifelse(grow$`6.3`=="Maskinelt",1,ifelse(grow$`6.3`=="Ikke aktuelt, det vaksineres ikke fisk på denne lokaliteten",1,0))
# #Hvem utfører vaksinering av fisk på denne lokaliteten?
# q111<-ifelse(grow$`6.4`=="Selskapets egne ansatte",1,ifelse(grow$`6.4`=="Innleid vaksineringspersonell",1,0))
# 
# 
# #weight of the questions
# w90<-1
# w91<-1
# w92<-1
# w93<-1
# w94<-1
# w95<-1
# w96<-1
# w97<-1
# w98<-1
# w99<-1
# w100<-1
# w101<-1
# w102<-1
# w103<-1
# w104<-1
# w105<-1
# w106<-1
# w107<-1
# w108<-1
# w109<-1
# w110<-1
# w111<-1 
# 
# sub8<-rowSums(cbind(q90*w90,q91*w91,q92*w92,q93*w93,q94*w94,q95*w95,q96*w96,q97*w97,q98*w98,q99*w99,q100*w100,q101*w101,q102*w102,q103*w103,q104*w104,q105*w105,q106*w106,q107*w107,q108*w108,q109*w109,q110*w110,q111*w111), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 22)
# su1.8<-(sub8/22)*100
# su1.8
# 
# #mean of the scores for this subcategory
# msu1.8<-mean(su1.8)
# msu1.8
# 
# summary(su1.8) 
# 
# 
# #9) DISEASE MANAGEMENT
# 
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av generell adferd hos fisken på lokaliteten
# q112<-ifelse(grow$`16.1.1`=="Minst to ganger daglig",1,ifelse(grow$`16.1.1`=="Minst en gang daglig",1,ifelse(grow$`16.1.1`=="Minst to ganger i uken",0.5,ifelse(grow$`16.1.1`=="Mindre enn to ganger i uken",0.2,ifelse(grow$`16.1.1`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Undersøke svimere og dødfisk for dødsårsak
# q113<-ifelse(grow$`16.1.2`=="Minst to ganger daglig",1,ifelse(grow$`16.1.2`=="Minst en gang daglig",1,ifelse(grow$`16.1.2`=="Minst to ganger i uken",0.5,ifelse(grow$`16.1.2`=="Mindre enn to ganger i uken",0.2,ifelse(grow$`16.1.2`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av merd og not
# q114<-ifelse(grow$`16.1.3`=="Minst to ganger daglig",1,ifelse(grow$`16.1.3`=="Minst en gang daglig",1,ifelse(grow$`16.1.3`=="Minst to ganger i uken",0.5,ifelse(grow$`16.1.3`=="Mindre enn to ganger i uken",0.2,ifelse(grow$`16.1.3`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av fôringsslanger og relaterte utstyr
# q115<-ifelse(grow$`16.1.4`=="Minst to ganger daglig",1,ifelse(grow$`16.1.4`=="Minst en gang daglig",1,ifelse(grow$`16.1.4`=="Minst to ganger i uken",0.5,ifelse(grow$`16.1.4`=="Mindre enn to ganger i uken",0.2,ifelse(grow$`16.1.4`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av fôringsadferd
# q116<-ifelse(grow$`16.1.5`=="Minst to ganger daglig",1,ifelse(grow$`16.1.5`=="Minst en gang daglig",1,ifelse(grow$`16.1.5`=="Minst to ganger i uken",0.5,ifelse(grow$`16.1.5`=="Mindre enn to ganger i uken",0.2,ifelse(grow$`16.1.5`=="Kontinuerlig kameraovervåkning",1,0))))) 
# #Hvor ofte registreres/loggføres død fisk på lokaliteten?
# q117<-ifelse(grow$`16.3`=="Daglig",1,ifelse(grow$`16.3`=="Ukentlig",0.5,ifelse(grow$`16.3`=="Månedlig",0.2,0)))
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Predatorer (feks, sel, oter, fugler, kannibalisme)
# q118<-ifelse(grow$`16.4.1`=="Ja",1,0)            
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Infeksiøse sykdommer
# q119<-ifelse(grow$`16.4.2`=="Ja",1,0)               
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Parasitter (f.eks. lakselus)
# q120<-ifelse(grow$`16.4.3`=="Ja",1,0)               
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Taperfisk (avmagrede fisk, "pinner" etc)
# q121<-ifelse(grow$`16.4.4`=="Ja",1,0)               
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Produksjonssykdommer
# q122<-ifelse(grow$`16.4.5`=="Ja",1,0)                
# #Fjernes død eller døende fisk daglig?
# q123<-ifelse(grow$`16.5`=="Ja",1,0)
# #Undersøkes død eller døende fisk rutinemessig for å finne dødsårsaken?
# q124<-ifelse(grow$`16.600000000000001`=="Ja",1,0)
# #Gjøres tiltak for å hindre direkte kontakt mellom syk fisk og annen fisk på lokaliteten?
# q125<-ifelse(grow$`16.7`=="Ja",1,0)
# #Hvor ofte blir det foretatt helsemessig gjennomgang av all fisk på lokaliteten?
# q126<-ifelse(grow$`17.100000000000001`=="Minst en gang i måneden",1,ifelse(grow$`17.100000000000001`=="Minst seks ganger i året",1,ifelse(grow$`17.100000000000001`=="Minst fire ganger i året",1,ifelse(grow$`17.100000000000001`=="Minst to ganger i året",0.5,ifelse(grow$`17.100000000000001`=="Minst en gang i året",0.5,0)))))
# #Finnes systemer for overvåkning av sykdommer på denne lokaliteten?
# q127<-ifelse(grow$`17.2`=="Ja",1,0)
# #Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Ved dødelighet eller adferdsendring uten kjent årsak
# q128<-ifelse(grow$`17.3.1`=="Ja",1,0)
# #Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Etter mottak av fisk fra annen lokalitet
# q129<-ifelse(grow$`17.3.2`=="Ja",1,0)
# #Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Ved forsendelse av fisk til annen lokalitet
# q130<-ifelse(grow$`17.3.3`=="Ja",1,0)
# #Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Rutinemessig; hyppighet av undersøkelsene avhenger av sykdomstype og tid på året.
# q131<-ifelse(grow$`17.3.4`=="Ja",1,0)
# #Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Hvis det er påvist viktig sykdom ved andre lokaliteter i området
# q132<-ifelse(grow$`17.3.5`=="Ja",1,0)
# #Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Ved myndighetspålagte undersøkelser
# q133<-ifelse(grow$`17.3.6`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når det er forhøyet dødelighet
# q134<-ifelse(grow$`17.4.1`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når sykdommen er ukjent eller uvanlig.
# q135<-ifelse(grow$`17.4.2`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når sykdomsutbruddet varer lenger enn forventet.
# q136<-ifelse(grow$`17.4.3`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når behandling/medisinering ikke hjelper.
# q137<-ifelse(grow$`17.4.4`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Utbrudd som er pålagt å rapportere.
# q138<-ifelse(grow$`17.4.5`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Ansatte informes med henvisning til lokalitetensbiosikkerhetsplaner
# q139<-ifelse(grow$`17.5.1`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Det innføres midlertidig stans av inntak av ny fisk i anlegget
# q140<-ifelse(grow$`17.5.2`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Undersøke vannkvalitet og ernæring
# q141<-ifelse(grow$`17.5.3`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Kontakte fiskehelsetjenesten man har avtale med, for prøveuttak og utredning av utbruddet
# q142<-ifelse(grow$`17.5.4`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Søke råd hos myndighetene
# q143<-ifelse(grow$`17.5.5`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Evaluere eksisterende biosikkerhetstiltak
# q144<-ifelse(grow$`17.5.6`=="Ja",1,0)
# #Hvem rapporteres sykdomsutbrudd til? Fiskehelsetjeneste man har avtale med
# q145<-ifelse(grow$`17.6.1`=="Ja",1,ifelse(grow$`17.6.1`=="Av og til",0.5,0))
# #Hvem rapporteres sykdomsutbrudd til? Mattilsynet
# q146<-ifelse(grow$`17.6.2`=="Ja",1,ifelse(grow$`17.6.2`=="Av og til",0.5,0))
# #Hvem rapporteres sykdomsutbrudd til? Til fiskehelseansvarlig i selskapet
# q147<-ifelse(grow$`17.6.3`=="Ja",1,ifelse(grow$`17.6.3`=="Av og til",0.5,0))
# #Hvem gjør prøveuttak ved sykdomsutbrudd?
# q148<-ifelse(grow$`17.7`=="Anleggets eget fiskehelsepersonell",1,ifelse(grow$`17.7`=="Fiskehelsetjeneste anlegget har avtale med",1,0))
# #Finnes det en egen beredskapsplan for sykdomsutbrudd og forøket dødelighet på lokaliteten?
# q149<-ifelse(grow$`17.899999999999999`=="Ja",1,0)
# #Finnes en beredskapsplan for miljøforurensing?
# q150<-ifelse(grow$`17.10`=="Ja",1,0)
# #Finnes en beredskapsplan i tilfelle feil på utstyr, feks fôringsutstyr?
# q151<-ifelse(grow$`17.11`=="Ja",1,0)
# 
# 
# #weight of the questions
# w112<-1
# w113<-1
# w114<-1
# w115<-1
# w116<-1
# w117<-1
# w118<-1
# w119<-1
# w120<-1
# w121<-1
# w122<-1
# w123<-1
# w124<-1
# w125<-1
# w126<-1
# w127<-1
# w128<-1
# w129<-1
# w130<-1
# w131<-1
# w132<-1
# w133<-1
# w134<-1
# w135<-1
# w136<-1
# w137<-1
# w138<-1
# w139<-1
# w140<-1
# w141<-1
# w142<-1
# w143<-1
# w144<-1
# w145<-1
# w146<-1
# w147<-1
# w148<-1
# w149<-1
# w150<-1
# w151<-1
# 
# 
# sub9<-rowSums(cbind(q112*w112,q113*w113,q114*w114,q115*w115,q116*w116,q117*w117,q118*w118,q119*w119,q120*w120,q121*w121,q122*w122,q123*w123,q124*w124,q125*w125,q126*w126,q127*w127,q128*w128,q129*w129,q130*w130,q131*w131,q132*w132,q133*w133,q134*w134,q135*w135,q136*w136,q137*w137,q138*w138,q139*w139,q140*w140,q141*w141,q142*w142,q143*w143,q144*w144,q145*w145,q146*w146,q147*w147,q148*w148,q149*w149,q150*w150,q151*w151), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 40)
# su1.9<-(sub9/40)*100
# su1.9
# 
# #mean of the scores for this subcategory
# msu1.9<-mean(su1.9)
# msu1.9
# 
# summary(su1.9) 
# 
# 
# #10) REARING MANAGEMENT
# 
# #Har lokaliteten definerte øvre grense for fisketettehet?
# q152<-ifelse(grow$`8.1`=="Ja",1,0)
# #Etterstrebes optimal fisketetthet som tiltak for å redusere stress hos fisken?
# q153<-ifelse(grow$`8.1999999999999993`=="Ja",1,0)
# #For sjø lokaliteter; Blir det flyttet fisk til eller fra denne lokaliteten etter første sjøsetting?
# q154<-ifelse(grow$`8.3000000000000007`=="Ja",1,ifelse(grow$`8.3000000000000007`=="Ikke aktuelt",1,0))
# #Har lokaliteten rutiner for å dokumentere uhell ved handtering av fisk?
# q155<-ifelse(grow$`8.4`=="Ja",1,0)
# #Har lokaliteten rutiner for å dokumentere optimal vannkvalitet?
# q156<-ifelse(grow$`8.5`=="Ja",1,0)
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Temperatur
# q157<-ifelse(grow$`8.6.1`=="Daglig",1,ifelse(grow$`8.6.1`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Oksygeninnhold
# q158<-ifelse(grow$`8.6.2`=="Daglig",1,ifelse(grow$`8.6.2`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad.Total mengde amoniakk
# q159<-ifelse(grow$`8.6.3`=="Daglig",1,ifelse(grow$`8.6.3`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Gassmetning
# q160<-ifelse(grow$`8.6.4`=="Daglig",1,ifelse(grow$`8.6.4`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad.Karbondioksyd
# q161<-ifelse(grow$`8.6.5`=="Daglig",1,ifelse(grow$`8.6.5`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. pH
# q162<-ifelse(grow$`8.6.6`=="Daglig",1,ifelse(grow$`8.6.6`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Vanngjennomstrømningsrate
# q163<-ifelse(grow$`8.6.7`=="Daglig",1,ifelse(grow$`8.6.7`=="Av og til",0.5,0))
# #Praktiseres "alt inn-alt ut"-prinsippet på lokaliteten? Med dette menes at ny fisk IKKE inkluderes i eksisterende fiskegrupper (dvs. samme not sjøanlegg eller samme avdeling, settefiskanlegg) i løpet av samme produksjonssyklus
# q164<-ifelse(grow$`8.6999999999999993`=="Ja",1,0)
# 
# #weight of the questions
# w152<-1
# w153<-1
# w154<-1
# w155<-1
# w156<-1
# w157<-1
# w158<-1
# w159<-1
# w160<-1
# w161<-1 
# w162<-1
# w163<-1
# w164<-1
# 
# 
#   
#   sub10<-rowSums(cbind(q152*w152,q153*w153,q154*w154,q155*w155,q156*w156,q157*w157,q158*w158,q159*w159,q160*w160,q161*w161,q162*w162,q163*w163,q164*w164), na.rm=TRUE)
# 
#   #(as each question as a weigth of 1 the maximum score of this subcategory is 13)
# su1.10<-(sub10/13)*100
# su1.10
# 
# #mean of the scores for this subcategory
# msu1.10<-mean(su1.10)
# msu1.10
# 
# summary(su1.10) 
# 
# #11)  FEED MANAGEMENT
# 
# #Hvor ofte inspiseres lagret fôr?
# q165<-ifelse(grow$`7.1`=="Daglig",1,ifelse(grow$`7.1`=="Minst en gang i uken",0.8,0))
# #Ved inspeksjon av lagret fôr, hvilke faktorer undersøkes? (Velg alle aktuelle alternativ)
# q166<-ifelse(grow$`7.2`=="Utløpsdato, Forurensing",1,ifelse(grow$`7.2`=="Utløpsdato",0.5,ifelse(grow$`7.2`=="Forurensing",0.5,0)))
# #Hvordan lagres fôret?
# q167<-ifelse(grow$`7.3`=="I lukkede beholdere, Kjølig og tørt, Utilgjengelig for skadedyr",1,ifelse(grow$`7.3`=="I lukkede beholdere, Kjølig og tørt",2/3,ifelse(grow$`7.3`=="I lukkede beholdere",1/3,ifelse(grow$`7.3`=="Kjølig og tørt, Utilgjengelig for skadedyr",2/3,ifelse(grow$`7.3`=="Utilgjengelig for skadedyr",1/3,ifelse(grow$`7.3`=="I lukkede beholdere, Utilgjengelig for skadedyr",2/3,ifelse(grow$`7.3`=="Kjølig og tørt",1/3,0)))))))
# #Hvordan fôres fisken i anlegget på denne lokaliteten? (Velg alle aktuelle alternativ)
# q168<-ifelse(grow$`7.4`=="Helautomatisk fôring",1,0)
# #Hvor ofte inspiseres fôringen?
# q169<-ifelse(grow$`7.5`=="Hver gang fisken fôres",1,ifelse(grow$`7.5`=="Daglig",1,ifelse(grow$`7.5`=="Minst en gang i uken",0.5,0)))
# 
# 
# #weight of the questions
# w165<-1
# w166<-1
# w167<-1
# w168<-1
# w169<-1
# 
# 
#  
# sub11<-rowSums(cbind(q165*w165,q166*w166,q167*w167,q168*w168,q169*w169), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 5)
# su1.11<-(sub11/5)*100
# su1.11
# 
# #mean of the scores for this subcategory
# msu1.11<-mean(su1.11)
# msu1.11
# 
# summary(su1.11)
# 
# 
# #12) WASTE MANAGEMENT
# 
# #Blir død fisk fra lokaliteten lagret i lukkede beholdere eller containere?
# q170<-ifelse(grow$`14.1`=="Ja",1,0)
# #Benytter lokaliteten vanntette beholdere for død fisk?
# q171<-ifelse(grow$`14.2`=="Ja",1,0)
# #Hvordan lagres død fisk på lokaliteten?
# q172<-ifelse(grow$`14.6`=="Frosset på -18 eller lavere",1,ifelse(grow$`14.6`=="Oppbevares kjølig (under 4C)",1,ifelse(grow$`14.6`=="Ensilert (ved pH under 4)",1,0)))
# #Hvor ofte fjernes vanligvis død fisk fra kar/merder?
# q173<-ifelse(grow$`14.7`=="Daglig",1,ifelse(grow$`14.7`=="Minst en gang i uken",0.5,0))
# 
# w170<-1
# w171<-1
# w172<-1
# w173<-1
#   
#  sub12<-rowSums(cbind(q170*w170,q171*w171,q172*w172,q173*w173), na.rm=TRUE)
# 
#  #(as each question as a weigth of 1 the maximum score of this subcategory is 4)
# su1.12<-(sub12/4)*100
# 
# #mean of the scores for this subcategory
# msu1.12<-mean(su1.12)
# msu1.12
# summary(su1.12)
# 
# 
# #13) HARVESTING
# 
# #Utføres det videreforedling og/eller pakking av produkter på lokaliteten?
# q174<-ifelse(grow$`15.1`=="Nei",1,0)
# #Ved forsendelse av fisk for videreforedling, kjører transportkjøretøyet direkte til videreforedlingsanlegget eller er det innom andre lokaliteter på veien?
# q175<-ifelse(grow$`15.2`=="Ja (kjører direkte til videreforedlingsanlegget)",1,ifelse(grow$`15.2`=="Ikke aktuelt",1,0))
# #Er det satt i verk tiltak ved slakting, for oppsamling og desinfeksjon av vann og blod? (Eksempelvis tiltak for å forhindre lekkasje fra slaktekasser).
# q176<-ifelse(grow$`15.3`=="Ja",1,ifelse(grow$`15.3`=="Ikke aktuelt",1,0))
# #Blir slakteutstyr vasket og desinfisert og undersøkt for skader, mellom to slaktinger?
# q177<-ifelse(grow$`15.4`=="Ja",1,ifelse(grow$`15.4`=="Ikke aktuelt",1,0))
# #Blir slakteutstyret bare brukt på dette anlegget, og ikke på andre anlegg?
# q178<-ifelse(grow$`15.5`=="Ja",1,ifelse(grow$`15.5`=="Ikke aktuelt",1,0))
# #Når vaskes og desinfiseres slakteutstyr? Før slakting
# q179<-ifelse(grow$`15.6.1`=="Ja",1,ifelse(grow$`15.6.1`=="Ikke aktuelt",1,0))
# #Når vaskes og desinfiseres slakteutstyr? Etter slakting
# q180<-ifelse(grow$`15.6.2`=="Ja",1,ifelse(grow$`15.6.2`=="Ikke aktuelt",1,0))
# #Når vaskes og desinfiseres slakteutstyr? Bare når det er nødvendig
# q181<-ifelse(grow$`15.6.3`=="Ja",1,ifelse(grow$`15.6.3`=="Ikke aktuelt",1,0))
# #For landbaserte anlegg: Blir innredninger (kar, tanker, renner eller lignende) vasket og desinfisert etter at fisken er fjernet?
# q182<-ifelse(grow$`15.7`=="Ja",1,ifelse(grow$`15.7`=="Ikke aktuelt",1,0))
# #For sjølokaliteter: Blir alt utstyr som har vært i kontakt med fisken (feks nøter og lignende) vasket og desinfisert, etter at fisken er fjernet?
# q183<-ifelse(grow$`15.8`=="Ja",1,ifelse(grow$`15.8`=="Ikke aktuelt",1,0))
# 
# 
# #weight of the questions
# w174<-1
# w175<-1
# w176<-1
# w177<-1
# w178<-1
# w179<-1
# w180<-1
# w181<-1
# w182<-1
# w183<-1
# 
# 
# 
#   
# sub13<-rowSums(cbind(q174*w174,q175*w175,q176*w176,q177*w177,q178*w178,q179*w179,q180*w180,q181*w181,q182*w182,q183*w183), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 10)
# su1.13<-(sub13/10)*100
# su1.13
# 
# #mean of the scores for this subcategory
# msu1.13<-mean(su1.13)
# msu1.13
# 
# summary(su1.13) 
# 
# 
# 
# #14) EQUIPMENT, CLEANING AND DISINFECTION ONSITE
# 
# #Hvor ofte rengjøres utstyr som brukes på de ulike vekststadier på lokaliteten (kar, renner, nøter eller lignende)? Velg alle aktuelle alternativ med èn markering pr. rad. Smolt
# q184<-ifelse(grow$`8.10.4`=="Daglig",1,ifelse(grow$`8.10.4`=="Minst en gang i uken",0.5,ifelse(grow$`8.10.4`=="Ikke aktuelt",1,0)))
# #Hvor ofte rengjøres utstyr som brukes på de ulike vekststadier på lokaliteten (kar, renner, nøter eller lignende)? Velg alle aktuelle alternativ med èn markering pr. rad.  Matfisk
# q185<-ifelse(grow$`8.10.5`=="Daglig",1,ifelse(grow$`8.10.5`=="Minst en gang i uken",0.5,ifelse(grow$`8.10.5`=="Ikke aktuelt",1,0)))
# #Hvis utstyr blir benyttet mange ulike steder på lokaliteten, blir utstyret RENGJORT før det flyttes fra ett sted til et annet på lokaliteten?
# q186<-ifelse(grow$`9.3000000000000007`=="Ja",1,0)
# #Hvis utstyr blir benyttet mange ulike steder på lokaliteten, blir utstyret DESINFISERT før det flyttes fra ett sted til et annet på lokaliteten?
# q187<-ifelse(grow$`9.4`=="Ja",1,0)
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q188<-ifelse(grow$`9.5.1`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(grow$`9.5.1`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(grow$`9.5.1`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q189<-ifelse(grow$`9.5.2`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(grow$`9.5.2`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(grow$`9.5.2`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q190<-ifelse(grow$`9.5.3`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(grow$`9.5.3`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(grow$`9.5.3`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q191<-ifelse(grow$`9.5.4`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(grow$`9.5.4`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(grow$`9.5.4`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q192<-ifelse(grow$`9.5.5`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(grow$`9.5.5`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(grow$`9.5.5`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q193<-ifelse(grow$`9.5.6`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(grow$`9.5.6`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(grow$`9.5.6`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Ved sykdomsutbrudd, benyttes utstyr som kun skal brukes på områder av lokaliteten som er smittet?
# q194<-ifelse(grow$`9.6`=="Ja",1,0)
# #Blir utstyret vasket (tanker / fartøyer / produksjonslinjer eller lignende) eller lar merdene stå tomme i en lengre periode etter at den syke / døde fisken er fjernet?
# q195<-ifelse(grow$`9.6999999999999993`=="Ja",1,0)
# #Hvilken beskyttelses-bekledning må personalet ha på seg, når de arbeider i anlegget?Overall/kjeledress, forkle (engangs- eller ikke-engangs)
# q196<-ifelse(grow$`11.5.1`=="Ja",1,0)
# #Hvilken beskyttelses-bekledning må personalet ha på seg, når de arbeider i anlegget? Fottøy
# q197<-ifelse(grow$`11.5.2`=="Ja",1,0)
# #Hvilken beskyttelses-bekledning må personalet ha på seg, når de arbeider i anlegget? Hansker
# q198<-ifelse(grow$`11.5.3`=="Ja",1,0)
# #Hvor ofte vaskes beskyttelses-bekledningen?
# q199<-ifelse(grow$`11.6`=="Minst en gang daglig",1,ifelse(grow$`11.6`=="Minst en gang i uken",0.5,0))
# #Hvor ofte desinfiseres beskyttelses-bekledning?
# q200<-ifelse(grow$`11.7`=="Minst en gang daglig",1,ifelse(grow$`11.7`=="Minst en gang i uken",0.5,0))
# #Benyttes spesielle og lett gjenkjennelige klær (feks med fargekoder) for hver av de ulike produksjonsenhetene på samme lokalitet?
# q201<-ifelse(grow$`11.9`=="Ja",1,0)
# #Finnes egne separate områder, innredninger, fasiliteter, utstyr og personell, som benyttes for håndtering av syk fisk?
# q202<-ifelse(grow$`16.8.1`=="Ja",1,0)
# #Finnes egne separate områder, innredninger, fasiliteter, utstyr og personell, som benyttes for håndtering av syk fisk?
# q203<-ifelse(grow$`16.8.2`=="Ja",1,0)
# #Finnes egne separate områder, innredninger, fasiliteter, utstyr og personell, som benyttes for håndtering av syk fisk?
# q204<- ifelse(grow$`16.8.3`=="Ja",1,0)
# #Hvis det ikke er mulig å benytte separate fasiliteter, utstyr og personell ved håndtering av syk fisk: Undersøkes og håndteres syk fisk til slutt?
# q205<-ifelse(grow$`16.899999999999999`=="Ja",1,0)
# #Vaskes og desinfiseres alt av utstyr, klær, støvler etc, som kommer i kontakt med syk fisk?
# q206<-ifelse(grow$`16.10`=="Ja",1,0)
# #Skal personale alltid vaske og desinfisere hendene etter kontakt med syk og død fisk?
# q207<-ifelse(grow$`16.11`=="Ja",1,0)
# 
# 
# #weight of the questions
# w184<-1
# w185<-1
# w186<-1
# w187<-1
# w188<-1
# w189<-1
# w190<-1
# w191<-1
# w192<-1
# w193<-1
# w194<-1
# w195<-1
# w196<-1
# w197<-1
# w198<-1
# w199<-1
# w200<-1
# w201<-1
# w202<-1
# w203<-1
# w204<-1
# w205<-1
# w206<-1
# w207<-1
# 
# 
#   
# sub14<-rowSums(cbind(q184*w184,q185*w185,q186*w186,q187*w187,q188*w188,q189*w189,q190*w190,q191*w191,q192*w192,q193*w193,q194*w194,q195*w195,q196*w196,q197*w197,q198*w198,q199*w199,q200*w200,q201*w201,q202*w202,q203*w203,q204*w204,q205*w205,q206*w206,q207*w207), na.rm=TRUE)
#  
# #(as each question as a weigth of 1 the maximum score of this subcategory is 24)
# su1.14<-(sub14/24)*100
# su1.14
# 
# #mean of the scores for this subcategory
# msu1.14<-mean(su1.14)
# msu1.14
# 
# summary(su1.14)
# 
# 
# 
# #15) BIOSECURITY PROGRAM AND RECORD KEEPING
# 
# #Har lokaliteten egen standard prosedyre for biosikkerhet (SOPs)?
# q208<-ifelse(grow$`18.100000000000001`=="Ja",1,0)
# #Hvor ofte får medarbeiderne gjennomgang og opplæring i biosikkerhetsprosedyren (SOP'en)?
# q209<-ifelse(grow$`18.2`=="Minst en gang i året",1,ifelse(grow$`18.2`=="Minst en gang hvert andre år",0.5,ifelse(grow$`18.2`=="Minst en gang hvert tredje år",0.2,0)))
# #Revideres denne lokaliteten regelmessig vha kvalitetsprogram som feks "Friends of the Sea", "GlobalGAP", etc ?
# q210<-ifelse(grow$`18.3`=="Ja",1,0)
# #Hvor ofte revideres biosikkerhetsprosedyren?
# q211<-ifelse(grow$`18.399999999999999`=="Minst en gang i året",1,ifelse(grow$`18.399999999999999`=="Minst en gang hvert andre år",0.5,ifelse(grow$`18.399999999999999`=="Minst en gang hvert tredje år",0.2,0)))
# #Registreres data fra følgende deler av virksomheten?
# q212<-ifelse(grow$`18.5.1`=="Ja",1,0)
# #Registreres data fra følgende deler av virksomheten?
# q213<-ifelse(grow$`18.5.2`=="Ja",1,0)
# #Registreres data fra følgende deler av virksomheten?
# q214<-ifelse(grow$`18.5.3`=="Ja",1,0)
# #Registreres data fra følgende deler av virksomheten?
# q215<-ifelse(grow$`18.5.4`=="Ja",1,0)
# #Registreres data fra følgende deler av virksomheten?
# q216<-ifelse(grow$`18.5.5`=="Ja",1,0)
# 
# 
# #weight of the questions
# w208<-1
# w209<-1
# w210<-1
# w211<-1
# w212<-1
# w213<-1
# w214<-1
# w215<-1
# w216<-1
# 
# 
# 
# sub15<-rowSums(cbind(q208*w208,q209*w209,q210*w210,q211*w211,q212*w212,q213*w213,q214*w214,q215*w215,q216*w216), na.rm=TRUE)
#   
# #(as each question as a weigth of 1 the maximum score of this subcategory is 9)
# su1.15<-(sub15/9)*100
# su1.15
#   
# #mean of the scores for this subcategory
# msu1.15<-mean(su1.15)
# msu1.15
# summary(su1.15) 
# 
# 
# 
# #Wheights for the subcategories
# ws1<-1
# ws2<-1
# ws3<-1
# ws4<-1
# ws5<-1
# ws6<-1
# ws7<-1
# ws8<-1
# ws9<-1
# ws10<-1
# ws11<-1
# ws12<-1
# ws13<-1
# ws14<-1
# ws15<-1
#   
#   
# 
#   #Subtotal of external biosecurity
#   
# external<-rowSums(cbind(su1.1*ws1,su1.2*ws2,su1.3*ws3,su1.4*ws4,su1.5*ws5,su1.6*ws6,su1.7*ws7), na.rm=TRUE)
# ext<-(external/7)
# ext
# 
# #mean score for external biosecurity
# mext<-mean(ext)
# mext
# summary(ext)
# 
# 
# 
# 
# #Subtotal of internal biosecurity
# internal<-rowSums(cbind(su1.8*ws8,su1.9*ws9,su1.10*ws10,su1.11*ws11,su1.12*ws12,su1.13*ws13,su1.14*ws14,su1.15*ws15), na.rm=TRUE)
# int<-(internal/8)
# int
# 
# #mean score for internal biosecurity
# mint<-mean(int)
# mint
# summary(int)
# 
# 
# 
#  #Not to use now
# total<-rowSums(cbind(su1.1*ws1,su1.2*ws2,su1.3*ws3,su1.4*ws4,su1.5*ws5,su1.6*ws6,su1.7*ws7,su1.8*ws8,su1.9*ws9,su1.10*ws10,su1.11*ws11,su1.12*ws12,su1.13*ws13,su1.14*ws14,su1.15*ws15), na.rm=TRUE)
# tot<-(total/15)
# tot
# summary(tot)
# 
# 
# 
# 
# 
# #Overall biosecurity-
# #we have to give weigth ro each category
# we<-0.5
# wi<-0.5
# 
# total<-round((ext*we)+(int*wi))
# total
# 
# #Mean of overall scores
# mtotal<-mean(total)
# mtotal
# summary(total)
# 
# #Data for APP
# myscore<-rbind(su1.1,su1.2,su1.3,su1.4,su1.5,su1.6,su1.7,ext,su1.8,su1.9,su1.10,su1.11,su1.12,su1.13,su1.14,su1.15,int,total)
# myscore
# 
# meanscore<-rbind(msu1.1,msu1.2,msu1.3,msu1.4,msu1.5,msu1.6,msu1.7,mext,msu1.8,msu1.9,msu1.10,msu1.11,msu1.12,msu1.13,msu1.14,msu1.15,mint,mtotal)
# meanscore
# 
# benchmarking<-cbind(myscore,meanscore)
# benchmarking
