# 
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
# #HATCHERY
# 
# data<-read_excel("Copy of Norsk_Farm questionnaire survey_15.07.2021_for testing (Responses) (1).xlsx")
# 
# 
#   
# #2.6 Hvilken type oppdrett utgjør hovedaktiviteten på denne lokaliteten?/2.6 What type of farming is the main activity at this locality? (Select only one option)
# sett<-filter(data, data$`2.6` =="Produksjon av settefisk" )  
# rogn<-filter(data, data$`2.6` =="Produksjon av rogn" )
# post<-filter(data, data$`2.6` =="Produksjon av postsmolt" )
# dataH<-rbind(sett,rogn,post)
# sette<-(dataH)
# 
# 
# 
# 
# 
# # 1) LOCATION OF THE FARM/Plassering av lokaliteten 
# 
# #1- full presence of biosecurity measure/ total absence of risk
# #0- total absence of biosecurity measure/ full presence of risk
# 
# 
# #2.9 Hvor er lokaliteten plassert?/2.9 Where is the site located? (on-land)
# q0<-ifelse(sette$`2.9` =="På land",1,0)
# # Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Settefiskanlegg]
# q1<-ifelse(sette$`2.10.1`=="Ingen",1,0)
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Postsmolt]
# q2<-ifelse(sette$`2.10.2` =="Ingen",1,0)     
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Matfisk]
# q3<-ifelse(sette$`2.10.3` =="Ingen",1,0)
# #Hvor mange aktive lokaliteter med laksefiskprosduksjon finnes innenfor en radius på 10 km fra denne lokaliteten? [Slakteri og/eller videreforedlingsbedrift]
# q4<-ifelse(sette$`2.10.4` =="Ingen",1,0)
# #Finnes det gjerder, porter eller skilt som advarer personer og kjøretøy mot adgang til anlegget uten tillatelse? 
# q5<-ifelse(sette$`8.8000000000000007`=="Ja",1,0)
# 
# #weight of the questions
# 
# w0<-1
# w1<-1
# w2<-1
# w3<-1
# w4<-1
# w5<-1
# 
#   
# sub1<-rowSums(cbind(q0*w0,q1*w1,q2*w2,q3*w3,q4*w4,q5*w5), na.rm=TRUE)
# #(as each question as a weigth of 1 the maximum score of this subcategory is 6)
# 
# su1.1<-(sub1/6)*100
# su1.1
# 
# #mean of the scores for this subcategory
# msu1.1<-mean(su1.1)
# msu1.1
# summary(su1.1)
# 
# 
# # 2)	Introduction of eggs/ Inntak av rogn på lokaliteten
# 
# #Er det egen protokol (SOP) for inntak av rogn?
# q6<-ifelse(sette$`4.0999999999999996`=="Ja",1,0)
# #Hvor mange forsendelser med rogn er tatt inn på denne lokaliteten i løpet av de siste 12 måneder? (Fra eget selskap)
# q7<-ifelse(sette$`4.2.1`=="Ingen",1,0)
# #Hvor mange forsendelser med rogn er tatt inn på denne lokaliteten i løpet av de siste 12 måneder? ( Fra eksternt selskap)
# q8<-ifelse(sette$`4.2.2`=="Ingen",1,0)
# #Krav ved inntak av rogn fra eget selskap-Vi krever helseattest/rapporter som dokumenterer fravær av viktige smittsomme agens i stamfiskpopulasjonen.
# q9<-ifelse(sette$`4.3.1`=="Ja",1,0)
# #Krav ved inntak av rogn fra eget selskap-Vi krever resultater fra diagnostiske undersøkelser som gjelder viktige smittsomme agens
# q10<-ifelse(sette$`4.3.2`=="Ja",1,0)
# #Krav ved inntak av rogn fra eget selskap-Vi krever oversikt over gjennomførte smittereduserende tiltak
# q11<-ifelse(sette$`4.3.3`=="Ja",1,0)
# #Krav ved inntak av rogn fra eget selskap-Vi undersøker rogn ved ankomst
# q12<-ifelse(sette$`4.3.4`=="Ja",1,0)
# #Krav ved inntak av rogn fra eget selskap-Vi undersøker rogn og anlegget den kommer fra, før vi bestiller
# q13<-ifelse(sette$`4.3.5`=="Ja",1,0)
# #Krav ved inntak av rogn fra ekternt selskap-Vi krever helseattest/rapporter som dokumenterer fravær av viktige smittsomme agens i stamfiskpopulasjonen.
# q14<-ifelse(sette$`4.4.1`=="Ja",1,0)
# #Krav ved inntak av rogn fra ekternt selskap-Vi krever resultater fra diagnostiske undersøkelser som gjelder viktige smittsomme agens
# q15<-ifelse(sette$`4.4.2`=="Ja",1,0)
# #Krav ved inntak av rogn fra ekternt selskap-Vi krever oversikt over gjennomførte smittereduserende tiltak
# q16<-ifelse(sette$`4.4.3`=="Ja",1,0)
# #Krav ved inntak av rogn fra ekternt selskap-Vi undersøker rogn ved ankomst
# q17<-ifelse(sette$`4.4.4`=="Ja",1,0)
# #Krav ved inntak av rogn fra ekternt selskap-Vi undersøker rogn og anlegget den kommer fra, før vi bestiller
# q18<-ifelse(sette$`4.4.5`=="Ja",1,0)
# #Foretas forbyggende behandling (desinfeksjon) av rogn ved ankomst til lokaliteten?
# q19<-ifelse(sette$`4.5` =="Ja",1,0)
# #Er det et eget område på lokaliteten som skal benyttes ved inntak av rogn?
# q20<-ifelse(sette$`4.5999999999999996` =="Ja",1,0)
# 
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
#   
#   
# sub2<-rowSums(cbind(q6*w6,q7*w7,q8*w8,q9*w9,q10*w10,q11*w11,q12*w12,q13*w13,q14*w14,q15*w15,q16*w16,q17*w17,q18*w18,q19*w19,q20*w20), na.rm=TRUE)
# #(as each question as a weigth of 1 the maximum score of this subcategory is 15)
# 
# su1.2<-(sub2/15)*100
# su1.2
# 
# #mean of the scores for this subcategory
# msu1.2<-mean(su1.2)
# msu1.2
# 
# summary(su1.2)
# 
# 
# 
# # 3) INTRODUCTION OF LIVE FISH ONTO THE FACILITY/Inntak av levende fisk på lokaliteten 
# 
# #Er det egen protokol (SOP) for inntak av fisk?
# q21<-ifelse(sette$`5.0999999999999996`=="Ja",1,0)
# #Hvor mange forsendelser med smolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder?-Fra eget selskap
# q22<-ifelse(sette$`5.2.1`=="Ingen",1,0)
# #Hvor mange forsendelser med smolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder?-Fra ekternt selskap
# q23<-ifelse(sette$`5.2.2`=="Ingen",1,0)
# #Hvor mange forsendelser med postsmolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder? Fra eget selskap
# q24<-ifelse(sette$`5.3.1`=="Ingen",1,0)
# #Hvor mange forsendelser med postsmolt har vært tatt inn på lokaliteten i løpet av de siste 12 måneder? Fra ekternt selskap
# q25<-ifelse(sette$`5.3.2`=="Ingen",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi krever helseattest/rapporter som dokumenterer fravær av viktige smittsomme agens i settefiskpopulasjonen
# q26<-ifelse(sette$`5.4.1`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi krever resultater fra diagnostiske undersøkelser som gjelder viktige smittsomme agens
# q27<-ifelse(sette$`5.4.2`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi krever oversikt over gjennomførte smittereduserende tiltak
# q28<-ifelse(sette$`5.4.3`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi undersøker fisk ved ankomst
# q29<-ifelse(sette$`5.4.4`=="Ja",1,0)
# #Krav ved inntak av fisk fra eget selskap-Vi undersøker fisk og opprinnelsesanlegg før bestilling
# q30<-ifelse(sette$`5.4.5`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi krever helseattest/rapporter som dokumenterer fravær av viktige smittsomme agens i settefiskpopulasjonen
# q31<-ifelse(sette$`5.5.1`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi krever resultater fra diagnostiske undersøkelser som gjelder viktige smittsomme agens
# q32<-ifelse(sette$`5.5.2`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi krever oversikt over gjennomførte smittereduserende tiltak
# q33<-ifelse(sette$`5.5.3`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi undersøker fisk ved ankomst
# q34<-ifelse(sette$`5.5.4`=="Ja",1,0)
# #Krav ved inntak av fisk fra ekternt selskap-Vi undersøker fisk og opprinnelsesanlegg før bestilling
# q35<-ifelse(sette$`5.5.5`=="Ja",1,0)
# # Skjer lossing av fisk i et eget område og / eller i avstand fra eksisterende fisk på lokaliteten?
# q36<-ifelse(sette$`5.6`=="Ja",1,0)
# #Kreves det at fisk som leveres til lokaliteten, skal settes i karantene ved ankomst?
# q37<-ifelse(sette$`5.7`=="Ja",1,0)
# #Har anlegget egne områder/innredninger som brukes til karantene?
# q38<-ifelse(sette$`5.8`=="Ja",1,0)
# #Gjennomføres nedvask av karanteneområdene etter hver gang de har vært i bruk?
# q39<-ifelse(sette$`5.9`=="Ja",1,0)
# # Inkluderes ny fisk i fiskegrupper som er i anlegget fra før (dvs. i samme not sjøanlegg eller samme avdeling, settefiskanlegg) i løpet av en produksjonssyklus
# q40<-ifelse(sette$`8.9`=="Ja",1,0)
# 
# 
# #weight of the questions
# w21<-1
# w22<-1
# w23<-1
# w24<-1
# w25<-1
# w26<-1
# w27<-1
# w28<-1
# w29<-1
# w30<-1
# w31<-1
# w32<-1
# w33<-1
# w34<-1
# w35<-1
# w36<-1
# w37<-1
# w38<-1
# w39<-1
# w40<-1
# 
# 
# 
# sub3<-rowSums(cbind(q21*w21,q22*w22,q23*w23,q24*w24,q25*w25,q26*w26,q27*w27,q28*w28,q29*w29,q30*w30,q31*w31,q32*w32,q33*w33,q34*w34,q35*w35,q36*w36,q37*w37,q38*w38,q39*w39,q40*w40), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 20)
# su1.3<-(sub3/20)*100
# su1.3
# 
# #mean of the scores for this subcategory
# msu1.3<-mean(su1.3)
# msu1.3
# 
# summary(su1.3)
# 
# 
# # 4) FEED AND WATER SUPPLY/FODER- OG VANNTILF?RSEL
# 
# #Hvilke vannkilder brukes på lokaliteten? # SARAYA WAS GOING TO THINK ABOUT THIS ONE 
# q41<-ifelse(sette$`3.1.1`=="Ja",1,0)
# #Behandling av inntaksvann-Filtrering
# q42<-ifelse(sette$`3.2.1`=="Ja",1,0)
# #Behandling av inntaksvann-Ultrafiolett stråling
# q43<-ifelse(sette$`3.2.2`=="Ja",1,0)
# #Behandling av inntaksvann-Ozon
# q44<-ifelse(sette$`3.2.3`=="Ja",1,0)
# #Behandling av inntaksvann-Fjerning av klor
# q45<-ifelse(sette$`3.2.4`=="Ja",1,0)
# #Behandling av inntaksvann-Justering av vannkjemi
# q46<-ifelse(sette$`3.2.5`=="Ja",1,0)
# #Blir avløpsvannet behandlet for å fjerne partikler?
# q47<-ifelse(sette$`3.3`=="Ja",1,0)
# #Blir avløpsvannet desinfisert?
# q48<-ifelse(sette$`3.5`=="Ja",1,0)
# # Benyttes frosset fisk, fiskeavfall eller annet rått fôr?
# q49<-ifelse(sette$`7.6`=="Nei",1,0)
# #Hvor ofte undersøkes frosset fisk, fiskeavfall eller levende fôr, for forekomst av patogener (feks bakterier og/eller virus)? 
# q50<-ifelse(sette$`7.7`=="Alle nye batcher",1, ifelse(sette$`7.7`=="Ikke aktuelt",1,0))
# 
# #weight of the questions
# w41<-1
# w42<-1
# w43<-1
# w44<-1
# w45<-1
# w46<-1
# w47<-1
# w48<-1  
# w49<-1
# w50<-1 
#    
#    
# sub4<-rowSums(cbind(q41*w41,q42*w42,q43*w43,q44*w44,q45*w45,q46*w46,q47*w47,q48*w48,q49*w49,q50*w50), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 10)
# su1.4<-(sub4/10)*100
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
# # 5) BIOVECTORS/BIOVEKTORER
# 
# #Er det satt i verk tiltak for å forhindre at predatorer og/eller åtseletere kommer inn på denne lokaliteten?
# q51<-ifelse(sette$`10.1`=="Ja",1,0)
# #Holdes fiskeavfall (eksempelvis død fisk, slaktet fisk, rester av fisk uegnet til menneskemat) unna predatorer/åtseletere?
# q52<-ifelse(sette$`10.199999999999999`=="Ja",1,0)
# #Holdes det oversikt over følgende:Tiltak som er satt i verk for å hindre predatorer
# q53<-ifelse(sette$`10.3.1`=="Ja",1,0)
# #Holdes det oversikt over følgende:Inspeksjoner av kontrolltiltak for å hindre predatorer
# q54<-ifelse(sette$`10.3.2`=="Ja",1,0)
# #Holdes det oversikt over følgende:Synsobservasjoner av relevante predatorer
# q55<-ifelse(sette$`10.3.3`=="Ja",1,0)
# #Holdes det oversikt over følgende:Tap på grunn av predatorer
# q56<-ifelse(sette$`10.3.4`=="Ja",1,0)
# 
# 
# #weight of the questions
# w51<-1
# w52<-1
# w53<-1
# w54<-1
# w55<-1
# w56<-1  
#   
# sub5<-rowSums(cbind(q51*w51,q52*w52,q53*w53,q54*w54,q55*w55,q56*w56), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 6)
# su1.5<-(sub5/6)*100
# su1.5
# 
# #mean of the scores for this subcategory
# msu1.5<-mean(su1.5)
# msu1.5
# 
# summary(su1.5)
# 
# 
# 
# # 6) PERSONNEL AND VISITORS
# 
# #Hvis et eksternt transportkjøretøy (bil, båt, etc.) benyttes, kan transportpersonalet bevege seg fritt på lokaliteten mens transporten pågår?
# q57<-ifelse(sette$`9.1199999999999992`=="Nei",1,ifelse(sette$`9.1199999999999992`=="Ikke aktuelt, fordi det ikke transporteres fisk til og fra denne lokaliteten",1,0))
# #Besøker noen av medarbeiderne på denne lokaliteten andre lokaliteter regelmessig?
# q58<-ifelse(sette$`11.1`=="Nei",1,0)
# #Har personalet på lokaliteten tilgang til desinfeksjonsstasjoner?
# q59<-ifelse(sette$`11.2`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved hovedinngangen(e)
# q60<-ifelse(sette$`11.3.1`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved hovedutgangen(e)
# q61<-ifelse(sette$`11.3.2`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved inngang til områder der fisk produseres
# q62<-ifelse(sette$`11.3.3`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Ved utgang fra områder der fisk produseres
# q63<-ifelse(sette$`11.3.4`=="Ja",1,0)
# #Hvor er desinfeksjonsstasjonene plassert? Det finnes ingen desinfeksjons-stasjoner
# q64<-ifelse(sette$`11.3.5`=="Nei",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene?
# q65<-ifelse(sette$`11.4.1`=="Ja",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene?
# q66<-ifelse(sette$`11.4.2`=="Ja",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene?
# q67<-ifelse(sette$`11.4.3`=="Ja",1,0)
# #Hva er tilgjengelig på desinfeksjons-stasjonene? Removed
# q68
# #Adgangskontroll: Kreves det at besøkende må melde fra til anleggets personale ved ankomst?
# q69<-ifelse(sette$`12.1`=="Ja",1,ifelse(sette$`12.1`=="Besøkende har ikke adgang",1,0))
# #Kreves det at besøkende følger anleggets biosikkerhets-krav?
# q70<-ifelse(sette$`12.2`=="Ja",1,ifelse(sette$`12.2`=="Besøkende har ikke adgang",1,0))
# #Er besøkende og trafikken på anlegget begrenset til det som er nødvendig for å opprettholde driften?
# q71<-ifelse(sette$`12.3`=="Ja",1,ifelse(sette$`12.3`=="Besøkende har ikke adgang",1,0))
# #Oppholder gjester seg alltid sammen med personalet på lokaliteten, mens de er på besøk?
# q72<-ifelse(sette$`12.4`=="Ja",1,ifelse(sette$`12.4`=="Besøkende har ikke adgang",1,0))
# #Er det et krav at besøkende må være i selskap med anleggets personale, for å kunne oppholde seg i produksjonsområder?
# q73<-ifelse(sette$`12.5`=="Ja",1,ifelse(sette$`12.5`=="Besøkende har ikke adgang",1,0))
# # Er det forbudt for besøkende å være i nærkontakt med, eller håndtere fisk (med mindre det er nødvendig for fiskens helse)?
# q74<-ifelse(sette$`12.6`=="Ja",1,ifelse(sette$`12.6`=="Besøkende har ikke adgang",1,0))
# #Må besøkende ha på seg beskyttelses-bekledning (feks overall/kjeledress, forkle, støvler)?
# q75<-ifelse(sette$`12.7`=="Ja",1,ifelse(sette$`12.7`=="Besøkende har ikke adgang",1,0))
# #Må besøkende signere dokumentasjon som bekrefter at de ikke har besøkt andre oppdrettslokaliteter i forkant av besøket på anlegget, eller alternativt oppgi detaljer knyttet til alle tidligere besøk?
# q76<-ifelse(sette$`12.8`=="Ja",1,ifelse(sette$`12.8`=="Besøkende har ikke adgang",1,0))
# 
# 
# #weight of the questions
# w57<-1
# w58<-1
# w59<-1
# w60<-1
# w61<-1
# w62<-1
# w63<-1    
# w64<-1
# w65<-1
# w66<-1
# w67<-1
# w68<-#Removed
# w69<-1
# w70<-1
# w71<-1
# w72<-1
# w73<-1
# w74<-1
# w75<-1
# w76<-1
#   
# sub6<-rowSums(cbind(q57*w57,q58*w58,q59*w59,q60*w60,q61*w61,q62*w62,q63*w63,q64*w64,q65*w65,q66*w66,q67*w67,q69*w69,q70*w70,q71*w71,q72*w72,q73*w73,q74*w74,q75*w75,q76*w76), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 19)
# su1.6<-(sub6/19)*100
# su1.6
# 
# #mean of the scores for this subcategory
# msu1.6<-mean(su1.6)
# msu1.6
# 
# summary(su1.6) 
# 
# 
# #7) EQUIPMENT AND VEHICLES FOR TRANSPORT OF LIVE FISH, FEED AND WASTE
# 
# #Hvor ofte i gjennomsnitt kommer det transportfartøy til denne lokaliteten i produksjonseyklusen?
# q77<-ifelse(sette$`2.11.1`=="Månedlig",0.5,ifelse(sette$`2.11.1`=="Aldri",1,0))
# #Hvor ofte i gjennomsnitt kommer det transportfartøy til denne lokaliteten i produksjonseyklusen?
# q78<-ifelse(sette$`2.11.2`=="Månedlig",0.5,ifelse(sette$`2.11.2`=="Aldri",1,0))
# #Hvor ofte i gjennomsnitt kommer det transportfartøy til denne lokaliteten i produksjonseyklusen?
# q79<-ifelse(sette$`2.11.3`=="Månedlig",0.5,ifelse(sette$`2.11.3`=="Aldri",1,0))
# #Brukes samme innredning og utstyr både til ny fisk og fisk som er i anlegget fra før?
# q78<-ifelse(sette$`5.10`=="Nei",1,0)
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Nøter
# q79<-ifelse(sette$`9.1.1`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.1`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.1`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Håver
# q80<-ifelse(sette$`9.1.2`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.2`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.2`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Sorteringsutstyr
# q81<-ifelse(sette$`9.1.3`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.3`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.3`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Pumper
# q82<-ifelse(sette$`9.1.4`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.4`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.4`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Vaksinasjonsutstyr
# q83<-ifelse(sette$`9.1.5`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.5`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.5`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Presenninger
# q84<-ifelse(sette$`9.1.6`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.6`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.6`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Lastebil
# q85<-ifelse(sette$`9.1.7`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.7`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.7`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Brønnbåt
# q86<-ifelse(sette$`9.1.8`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.8`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.8`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Fòringsutstyr
# q87<-ifelse(sette$`9.1.9`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.9`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.9`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Hvilke restriksjoner er innført for bruk/sambruk av utstyr og kjøretøy mellom lokaliteter eller mellom avdelinger? Flytende utstyr som båter, raftingbåter ol
# q88<-ifelse(sette$`9.1.10`=="Eies og benyttes bare på denne lokaliteten",1,ifelse(sette$`9.1.10`=="Ikke benyttet på denne lokaliteten",1,ifelse(sette$`9.1.10`=="Fellesbruk bare med andre lokaliteter eid av samme selskap",0.5,0)))
# #Blir utstyr som benyttes felles, vasket og desinfisert før det benyttes på ANDRE lokaliteter/avdelinger?
# q89<-ifelse(sette$`9.1999999999999993`=="Ja",1,ifelse(sette$`9.1999999999999993`=="Vi har ikke felles bruk med andre lokaliteter",1,0))
# # Blir transportkjøretøy (bil, båt, etc.) kontrollert ved ankomst?
# q90<-ifelse(sette$`9.8000000000000007`=="Ja",1,0)
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Rogn
# q91<-ifelse(sette$`9.9.1`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(sette$`9.9.1`=="Ikke aktuelt",1,ifelse(sette$`9.9.1`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Fisk
# q92<-ifelse(sette$`9.9.2`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(sette$`9.9.2`=="Ikke aktuelt",1,ifelse(sette$`9.9.2`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Fôr
# q93<-ifelse(sette$`9.9.3`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(sette$`9.9.3`=="Ikke aktuelt",1,ifelse(sette$`9.9.3`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvilke transportkjøretøy (bil, båt, etc.) benyttes for transport av produkter til denne lokaliteten? Avfall
# q94<-ifelse(sette$`9.9.4`=="Transportkjøretøy som bare benyttes på denne lokaliteten",1,ifelse(sette$`9.9.4`=="Ikke aktuelt",1,ifelse(sette$`9.9.4`=="Transportkjøretøy som er felles med andre lokaliteter i samme selskap",0.5,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Rogn
# q95<-ifelse(sette$`9.10.1`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(sette$`9.10.1`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(sette$`9.10.1`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Fisk
# q96<-ifelse(sette$`9.10.2`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(sette$`9.10.2`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(sette$`9.10.2`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Fòr
# q97<-ifelse(sette$`9.10.3`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(sette$`9.10.3`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(sette$`9.10.3`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis eget transportkjøretøy (bil, båt, etc.) benyttes, hvordan gjennomføres rengjøring og desinfeksjon av kjøretøyet? Avfall
# q98<-ifelse(sette$`9.10.4`=="Vi sjekker og signerer OK rengjøring og desinfeksjonsprotokoller, før lasting",1,ifelse(sette$`9.10.4`=="Vi utfører selv rengjøring og desinfeksjon på lokaliteten, før lasting",1,ifelse(sette$`9.10.4`=="Ikke aktuelt, da vi ikke transporterer dette til og fra lokaliteten",1,0)))
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q99<-ifelse(sette$`9.11.1`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q100<-ifelse(sette$`9.11.2`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q101<-ifelse(sette$`9.11.3`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q102<-ifelse(sette$`9.11.4`=="Ja",1/4,0)
# #Hvis ekstern transportkjøretøy (bil, båt, etc.) benyttes, hvilken dokumentasjon må legges frem før ankomst?
# q103<-ifelse(sette$`9.11.5`=="Ja",1,0)
# #Er tomme transportkjøretøy (bil, båt, etc.) desinfisert (inni og utenpå) når de forlater lokaliteten?
# q104<-ifelse(sette$`9.1300000000000008`=="Ja",1,ifelse(sette$`9.1300000000000008`=="Ikke aktuelt, fordi det ikke transporteres fisk til og fra denne lokaliteten",1,0))
# #Mottar lokaliteten død fisk fra andre anlegg/lokaliteter?
# q105<-ifelse(sette$`14.3`=="Nei",1,0)
# #Leverer lokaliteten død fisk til andre anlegg/lokaliteter?
# q106<-ifelse(sette$`14.4`=="Nei",1,0)
# #Benytter lokaliteten eksterne selskap for henting av død fisk?
# q107<-ifelse(sette$`14.5`=="Nei",1,0)
# 
# #weight of the questions
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
# 
# 
# 
# sub7<-rowSums(cbind(q77*w77,q78*w78,q79*w79,q80*w80,q81*w81,q82*w82,q83*w83,q84*w84,q85*w85,q86*w86,q87*w87,q88*w88,q89*w89,q90*w90,q91*w91,q92*w92,q93*w93,q94*w94,q95*w95,q96*w96,q97*w97,q98*w98,q99*w99,q100*w100,q101*w101,q102*w102,q103*w103,q104*w104,q105*w105,q106*w106,q107*w107), na.rm=TRUE)
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
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? IPN
# q108<-ifelse(sette$`6.1.1`=="Ikke aktuell",1,ifelse(sette$`6.1.1`=="Liten betydning",0.5,ifelse(sette$`6.1.1`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? PD
# q109<-ifelse(sette$`6.1.2`=="Ikke aktuell",1,ifelse(sette$`6.1.2`=="Liten betydning",0.5,ifelse(sette$`6.1.2`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? ISA
# q110<-ifelse(sette$`6.1.3`=="Ikke aktuell",1,ifelse(sette$`6.1.3`=="Liten betydning",0.5,ifelse(sette$`6.1.3`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? VIBRIOSE
# q111<-ifelse(sette$`6.1.4`=="Ikke aktuell",1,ifelse(sette$`6.1.4`=="Liten betydning",0.5,ifelse(sette$`6.1.4`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? FURUNKULOSE
# q112<-ifelse(sette$`6.1.5`=="Ikke aktuell",1,ifelse(sette$`6.1.5`=="Liten betydning",0.5,ifelse(sette$`6.1.5`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Vintersår
# q113<-ifelse(sette$`6.1.6`=="Ikke aktuell",1,ifelse(sette$`6.1.6`=="Liten betydning",0.5,ifelse(sette$`6.1.6`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Kaldtvannsvibriose
# q114<-ifelse(sette$`6.1.7`=="Ikke aktuell",1,ifelse(sette$`6.1.7`=="Liten betydning",0.5,ifelse(sette$`6.1.7`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Yersiniose
# q115<-ifelse(sette$`6.1.8`=="Ikke aktuell",1,ifelse(sette$`6.1.8`=="Liten betydning",0.5,ifelse(sette$`6.1.8`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Flavobakteriose
# q116<-ifelse(sette$`6.1.9`=="Ikke aktuell",1,ifelse(sette$`6.1.9`=="Liten betydning",0.5,ifelse(sette$`6.1.9`=="Moderat betydning",0.5,0)))
# #Hvilke sykdommer har hatt betydning for tap (dødelighet og tilvekst) på denne lokaliteten de siste 12 mnd? Pasteurellose
# q117<-ifelse(sette$`6.1.10`=="Ikke aktuell",1,ifelse(sette$`6.1.10`=="Liten betydning",0.5,ifelse(sette$`6.1.10`=="Moderat betydning",0.5,0)))
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? IPN
# q118<-ifelse(sette$`6.2.1`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? PD
# q119<-ifelse(sette$`6.2.2`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? ISA
# q120<-ifelse(sette$`6.2.3`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? VIBRIOSE
# q121<-ifelse(sette$`6.2.4`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? FURUNKULOSE
# q122<-ifelse(sette$`6.2.5`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? VINTERSAR
# q123<-ifelse(sette$`6.2.6`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Kaldtvannsvibriose
# q124<-ifelse(sette$`6.2.7`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Yersiniose
# q125<-ifelse(sette$`6.2.8`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Flavobakteriose
# q126<-ifelse(sette$`6.2.9`=="Ja",1,0)
# #Er fisken på lokaliteten vaksinert mot følgende sykdommer? Pasteurellose
# q127<-ifelse(sette$`6.2.10`=="Ja",1,0)
# ##Hvordan utføres vaksinering av fisk på denne lokaliteten?
# q128<-ifelse(sette$`6.3`=="Maskinelt",1,ifelse(sette$`6.3`=="Ikke aktuelt, det vaksineres ikke fisk på denne lokaliteten",1,0))
# #Hvem utfører vaksinering av fisk på denne lokaliteten?
# q129<-ifelse(sette$`6.4`=="Selskapets egne ansatte",1,ifelse(sette$`6.4`=="Innleid vaksineringspersonell",1,0))
# 
# #weight of the questions
# w108<-1
# w109<-1
# w110<-1
# w111<-1
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
# 
# sub8<-rowSums(cbind(q108*w108,q109*w109,q110*w110,q111*w111,q112*w112,q113*w113,q114*w114,q115*w115,q116*w116,q117*w117,q118*w118,q119*w119,q120*w120,q121*w121,q122*w122,q123*w123,q124*w124,q125*w125,q126*w126,q127*w127,q128*w128,q129*w129), na.rm=TRUE)
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
# 
# #9) DISEASE MANAGEMENT
# 
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av generell adferd hos fisken på lokaliteten
# q130<-ifelse(sette$`16.1.1`=="Minst to ganger daglig",1,ifelse(sette$`16.1.1`=="Minst en gang daglig",1,ifelse(sette$`16.1.1`=="Minst to ganger i uken",0.5,ifelse(sette$`16.1.1`=="Mindre enn to ganger i uken",0.2,ifelse(sette$`16.1.1`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Undersøke svimere og dødfisk for dødsårsak   
# q131<-ifelse(sette$`16.1.2`=="Minst to ganger daglig",1,ifelse(sette$`16.1.2`=="Minst en gang daglig",1,ifelse(sette$`16.1.2`=="Minst to ganger i uken",0.5,ifelse(sette$`16.1.2`=="Mindre enn to ganger i uken",0.2,ifelse(sette$`16.1.2`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av merd og not
# q132<-ifelse(sette$`16.1.3`=="Minst to ganger daglig",1,ifelse(sette$`16.1.3`=="Minst en gang daglig",1,ifelse(sette$`16.1.3`=="Minst to ganger i uken",0.5,ifelse(sette$`16.1.3`=="Mindre enn to ganger i uken",0.2,ifelse(sette$`16.1.3`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av fôringsslanger og relaterte utstyr
# q133<-ifelse(sette$`16.1.4`=="Minst to ganger daglig",1,ifelse(sette$`16.1.4`=="Minst en gang daglig",1,ifelse(sette$`16.1.4`=="Minst to ganger i uken",0.5,ifelse(sette$`16.1.4`=="Mindre enn to ganger i uken",0.2,ifelse(sette$`16.1.4`=="Kontinuerlig kameraovervåkning",1,0)))))
# #Hvor ofte utføres følgende inspeksjoner i anlegget? Overvåkning av fôringsadferd  
# q134<-ifelse(sette$`16.1.5`=="Minst to ganger daglig",1,ifelse(sette$`16.1.5`=="Minst en gang daglig",1,ifelse(sette$`16.1.5`=="Minst to ganger i uken",0.5,ifelse(sette$`16.1.5`=="Mindre enn to ganger i uken",0.2,ifelse(sette$`16.1.5`=="Kontinuerlig kameraovervåkning",1,0))))) 
# #Hvor ofte registreres/loggføres død fisk på lokaliteten?             
# q135<-ifelse(sette$`16.3`=="Daglig",1,ifelse(sette$`16.3`=="Ukentlig",0.5,ifelse(sette$`16.3`=="Månedlig",0.2,0)))
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Predatorer (feks, sel, oter, fugler, kannibalisme)
# q136<-ifelse(sette$`16.4.1`=="Ja",1,0)            
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Infeksiøse sykdommer            
# q137<-ifelse(sette$`16.4.2`=="Ja",1,0)               
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Parasitter (f.eks. lakselus)            
# q138<-ifelse(sette$`16.4.3`=="Ja",1,0)               
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Taperfisk (avmagrede fisk, "pinner" etc)            
# q139<-ifelse(sette$`16.4.4`=="Ja",1,0)               
# #Ved registrering av dødfisk, blir dødefisk kategoriset i henhold til dødsårsak? Produksjonssykdommer            
# q140<-ifelse(sette$`16.4.5`=="Ja",1,0)   
# #Fjernes død eller døende fisk daglig?
# q141<-ifelse(sette$`16.5`=="Ja",1,0)
# #Undersøkes død eller døende fisk rutinemessig for å finne dødsårsaken?
# q142<-ifelse(sette$`16.600000000000001`=="Ja",1,0)
# #Gjøres tiltak for å hindre direkte kontakt mellom syk fisk og annen fisk på lokaliteten?
# q143<-ifelse(sette$`16.7`=="Ja",1,0)
# #Hvor ofte blir det foretatt helsemessig gjennomgang av all fisk på lokaliteten?
# q144<-ifelse(sette$`17.100000000000001`=="Minst en gang i måneden",1,ifelse(sette$`17.100000000000001`=="Minst seks ganger i året",1,ifelse(sette$`17.100000000000001`=="Minst fire ganger i året",1,ifelse(sette$`17.100000000000001`=="Minst to ganger i året",0.5,ifelse(sette$`17.100000000000001`=="Minst en gang i året",0.5,0)))))
# #Finnes systemer for overvåkning av sykdommer på denne lokaliteten?
# q145<-ifelse(sette$`17.2`=="Ja",1,0)
# # Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Ved dødelighet eller adferdsendring uten kjent årsak
# q146<-ifelse(sette$`17.3.1`=="Ja",1,0)
# # Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Etter mottak av fisk fra annen lokalitet
# q147<-ifelse(sette$`17.3.2`=="Ja",1,0)
# # Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Ved forsendelse av fisk til annen lokalitet
# q148<-ifelse(sette$`17.3.3`=="Ja",1,0)
# # Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Rutinemessig; hyppighet av undersøkelsene avhenger av sykdomstype og tid på året.
# q149<-ifelse(sette$`17.3.4`=="Ja",1,0)
# # Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Hvis det er påvist viktig sykdom ved andre lokaliteter i området
# q150<-ifelse(sette$`17.3.5`=="Ja",1,0)
# # Blir det gjennomført diagnostiske undersøkelser for å avdekke smitte/sykdom hos fisken? Ved myndighetspålagte undersøkelser
# q151<-ifelse(sette$`17.3.6`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når det er forhøyet dødelighet
# q152<-ifelse(sette$`17.4.1`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når sykdommen er ukjent eller uvanlig.
# q153<-ifelse(sette$`17.4.2`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når sykdomsutbruddet varer lenger enn forventet.
# q154<-ifelse(sette$`17.4.3`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Når behandling/medisinering ikke hjelper.
# q155<-ifelse(sette$`17.4.4`=="Ja",1,0)
# #Når vil utbrudd av sykdom/dødelighet på lokaliteten bli rapportert? Utbrudd som er pålagt å rapportere.
# q156<-ifelse(sette$`17.4.5`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Ansatte informes med henvisning til lokalitetensbiosikkerhetsplaner
# q157<-ifelse(sette$`17.5.1`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Det innføres midlertidig stans av inntak av ny fisk i anlegget
# q158<-ifelse(sette$`17.5.2`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Undersøke vannkvalitet og ernæring
# q159<-ifelse(sette$`17.5.3`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Kontakte fiskehelsetjenesten man har avtale med, for prøveuttak og utredning av utbruddet
# q160<-ifelse(sette$`17.5.4`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Søke råd hos myndighetene
# q161<-ifelse(sette$`17.5.5`=="Ja",1,0)
# #Blir disse tiltakene gjennomført ved sykdomsutbrudd? Evaluere eksisterende biosikkerhetstiltak
# q162<-ifelse(sette$`17.5.6`=="Ja",1,0)
# #Hvem rapporteres sykdomsutbrudd til? Fiskehelsetjeneste man har avtale med
# q163<-ifelse(sette$`17.6.1`=="Ja",1,ifelse(sette$`17.6.1`=="Av og til",0.5,0))
# #Hvem rapporteres sykdomsutbrudd til? Mattilsynet
# q164<-ifelse(sette$`17.6.2`=="Ja",1,ifelse(sette$`17.6.2`=="Av og til",0.5,0))
# #Hvem rapporteres sykdomsutbrudd til? Til fiskehelseansvarlig i selskapet
# q165<-ifelse(sette$`17.6.3`=="Ja",1,ifelse(sette$`17.6.3`=="Av og til",0.5,0))
# #Hvem gjør prøveuttak ved sykdomsutbrudd?
# q166<-ifelse(sette$`17.7`=="Anleggets eget fiskehelsepersonell",1,ifelse(sette$`17.7`=="Fiskehelsetjeneste anlegget har avtale med",1,0))
# #Finnes det en egen beredskapsplan for sykdomsutbrudd og forøket dødelighet på lokaliteten?
# q167<-ifelse(sette$`17.899999999999999`=="Ja",1,0)
# #Finnes en beredskapsplan for miljøforurensing?
# q168<-ifelse(sette$`17.10`=="Ja",1,0)
# #Finnes en beredskapsplan i tilfelle feil på utstyr, feks fôringsutstyr?
# q169<-ifelse(sette$`17.11`=="Ja",1,0)
# 
# 
# #weight of the questions
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
# w165<-1
# w166<-1
# w167<-1
# w168<-1
# w169<-1
#   
#   
# sub9<-rowSums(cbind(q130*w130,q131*w131,q132*w132,q133*w133,q134*w134,q135*w135,q136*w136,q137*w137,q138*w138,q139*w139,q140*w140,q141*w141,q142*w142,q143*w143,q144*w144,q145*w145,q146*w146,q147*w147,q148*w148,q149*w149,q150*w150,q151*w151,q152*w152,q153*w153,q154*w154,q155*w155,q156*w156,q157*w157,q158*w158,q159*w159,q160*w160,q161*w161,q162*w162,q163*w163,q164*w164,q165*w165,q166*w166,q167*w167,q168*w168,q169*w169), na.rm=TRUE)
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
# 
# #10) REARING MANAGEMENT
# 
# #Har lokaliteten definerte øvre grense for fisketettehet?
# q170<-ifelse(sette$`8.1`=="Ja",1,0)
# #Etterstrebes optimal fisketetthet som tiltak for å redusere stress hos fisken?
# q171<-ifelse(sette$`8.1999999999999993`=="Ja",1,0)
# #Har lokaliteten rutiner for å dokumentere uhell ved handtering av fisk?
# q172<-ifelse(sette$`8.4`=="Ja",1,0)
# #Har lokaliteten rutiner for å dokumentere optimal vannkvalitet?
# q173<-ifelse(sette$`8.5`=="Ja",1,0)
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Temperatur
# q174<-ifelse(sette$`8.6.1`=="Daglig",1,ifelse(sette$`8.6.1`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Oksygeninnhold
# q175<-ifelse(sette$`8.6.2`=="Daglig",1,ifelse(sette$`8.6.2`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad.Total mengde amoniakk
# q176<-ifelse(sette$`8.6.3`=="Daglig",1,ifelse(sette$`8.6.3`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Gassmetning
# q177<-ifelse(sette$`8.6.4`=="Daglig",1,ifelse(sette$`8.6.4`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad.Karbondioksyd
# q178<-ifelse(sette$`8.6.5`=="Daglig",1,ifelse(sette$`8.6.5`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. pH
# q179<-ifelse(sette$`8.6.6`=="Daglig",1,ifelse(sette$`8.6.6`=="Av og til",0.5,0))
# #Hvilke vannkvalitetsparameter blir monitorert/overvåket? Velg alle aktuelle alternativ, med èn markering pr. rad. Vanngjennomstrømningsrate
# q180<-ifelse(sette$`8.6.7`=="Daglig",1,ifelse(sette$`8.6.7`=="Av og til",0.5,0))
# #Praktiseres "alt inn-alt ut"-prinsippet på lokaliteten? Med dette menes at ny fisk IKKE inkluderes i eksisterende fiskegrupper (dvs. samme not sjøanlegg eller samme avdeling, settefiskanlegg) i løpet av samme produksjonssyklus
# q181<-ifelse(sette$`8.6999999999999993`=="Ja",1,0)
# 
# 
# #weight of the questions
# w170<-1
# w171<-1
# w172<-1
# w173<-1
# w174<-1
# w175<-1
# w176<-1
# w177<-1
# w178<-1
# w179<-1
# w180<-1
# w181<-1 
#   
#   
#   
#   
#   
# sub10<-rowSums(cbind(q170*w170,q171*w171,q172*w172,q173*w173,q174*w174,q175*w175,q176*w176,q177*w177,q178*w178,q179*w179,q180*w180,q181*w181), na.rm=TRUE)
# 
#   #(as each question as a weigth of 1 the maximum score of this subcategory is 12)
# su1.10<-(sub10/12)*100
# su1.10
# 
# #mean of the scores for this subcategory
# msu1.10<-mean(su1.10)
# msu1.10
# 
# 
# summary(su1.10)   
# 
# 
# #11) FEED MANAGEMENT
# 
# #Hvor ofte inspiseres lagret fôr?
# q182<-ifelse(sette$`7.1`=="Daglig",1,ifelse(sette$`7.1`=="Minst en gang i uken",0.8,0))
# #Ved inspeksjon av lagret fôr, hvilke faktorer undersøkes? (Velg alle aktuelle alternativ)
# q183<-ifelse(sette$`7.2`=="Utløpsdato, Forurensing",1,ifelse(sette$`7.2`=="Utløpsdato",0.5,ifelse(sette$`7.2`=="Forurensing",0.5,0)))
# #Hvordan lagres fôret?
# q184<-ifelse(sette$`7.3`=="I lukkede beholdere, Kjølig og tørt, Utilgjengelig for skadedyr",1,ifelse(sette$`7.3`=="I lukkede beholdere, Kjølig og tørt",2/3,ifelse(sette$`7.3`=="I lukkede beholdere",1/3,ifelse(sette$`7.3`=="Kjølig og tørt, Utilgjengelig for skadedyr",2/3,ifelse(sette$`7.3`=="Utilgjengelig for skadedyr",1/3,ifelse(sette$`7.3`=="I lukkede beholdere, Utilgjengelig for skadedyr",2/3,ifelse(sette$`7.3`=="Kjølig og tørt",1/3,0)))))))
# #Hvordan fôres fisken i anlegget på denne lokaliteten? (Velg alle aktuelle alternativ)
# q185<-ifelse(sette$`7.4`=="Helautomatisk fôring",1,0)
# #Hvor ofte inspiseres fôringen?
# q186<-ifelse(sette$`7.5`=="Hver gang fisken fôres",1,ifelse(sette$`7.5`=="Daglig",1,ifelse(sette$`7.5`=="Minst en gang i uken",0.5,0)))
# 
# #weight of the questions
# w182<-1
# w183<-1
# w184<-1
# w185<-1
# w186<-1  
# 
# 
# 
# 
# sub11<-rowSums(cbind(q182*w182,q183*w183,q184*w184,q185*w185,q186*w186), na.rm=TRUE)
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
# 
# #12) WASTE MANAGEMENT
# 
# #Blir død fisk fra lokaliteten lagret i lukkede beholdere eller containere?
# q187<-ifelse(sette$`14.1`=="Ja",1,0)
# #Benytter lokaliteten vanntette beholdere for død fisk?
# q188<-ifelse(sette$`14.2`=="Ja",1,0)
# #Hvordan lagres død fisk på lokaliteten?
# q189<-ifelse(sette$`14.6`=="Frosset på -18 eller lavere",1,ifelse(sette$`14.6`=="Oppbevares kjølig (under 4C)",1,ifelse(sette$`14.6`=="Ensilert (ved pH under 4)",1,0)))
# #Hvor ofte fjernes vanligvis død fisk fra kar/merder?
# q190<-ifelse(sette$`14.7`=="Daglig",1,ifelse(sette$`14.7`=="Minst en gang i uken",0.5,0))
# 
# #weight of the questions
# w187<-1
# w188<-1
# w189<-1
# w190<-1
# 
# 
# 
# sub12<-rowSums(cbind(q187*w187,q188*w188,q189*w189,q190*w190), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 4)
# su1.12<-(sub12/4)*100
# su1.12
# 
# #mean of the scores for this subcategory
# msu1.12<-mean(su1.12)
# msu1.12
# 
# 
# summary(su1.12)
# 
# 
# 
# #13) EQUIPMENT, CLEANING AND DISINFECTION ONSITE
# #Hvor ofte rengjøres utstyr som brukes på de ulike vekststadier på lokaliteten (kar, renner, nøter eller lignende)? Velg alle aktuelle alternativ med èn markering pr. rad. Rogn
# q191<-ifelse(sette$`8.10.1`=="Daglig",1,ifelse(sette$`8.10.1`=="Minst en gang i uken",0.5,ifelse(sette$`8.10.1`=="Ikke aktuelt",1,0)))
# #Hvor ofte rengjøres utstyr som brukes på de ulike vekststadier på lokaliteten (kar, renner, nøter eller lignende)? Velg alle aktuelle alternativ med èn markering pr. rad. Plommesekkyngel
# q192<-ifelse(sette$`8.10.2`=="Daglig",1,ifelse(sette$`8.10.2`=="Minst en gang i uken",0.5,ifelse(sette$`8.10.2`=="Ikke aktuelt",1,0)))
# #Hvor ofte rengjøres utstyr som brukes på de ulike vekststadier på lokaliteten (kar, renner, nøter eller lignende)? Velg alle aktuelle alternativ med èn markering pr. rad. Yengel
# q193<-ifelse(sette$`8.10.3`=="Daglig",1,ifelse(sette$`8.10.3`=="Minst en gang i uken",0.5,ifelse(sette$`8.10.3`=="Ikke aktuelt",1,0)))
# #Hvor ofte rengjøres utstyr som brukes på de ulike vekststadier på lokaliteten (kar, renner, nøter eller lignende)? Velg alle aktuelle alternativ med èn markering pr. rad. Stamfisk
# q194<-ifelse(sette$`8.10.6`=="Daglig",1,ifelse(sette$`8.10.6`=="Minst en gang i uken",0.5,ifelse(sette$`8.10.6`=="Ikke aktuelt",1,0)))
# #Hvis utstyr blir benyttet mange ulike steder på lokaliteten, blir utstyret RENGJORT før det flyttes fra ett sted til et annet på lokaliteten?
# q195<-ifelse(sette$`9.3000000000000007`=="Ja",1,0)
# #Hvis utstyr blir benyttet mange ulike steder på lokaliteten, blir utstyret DESINFISERT før det flyttes fra ett sted til et annet på lokaliteten?
# q196<-ifelse(sette$`9.4`=="Ja",1,0)
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q197<-ifelse(sette$`9.5.1`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(sette$`9.5.1`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(sette$`9.5.1`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q198<-ifelse(sette$`9.5.2`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(sette$`9.5.2`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(sette$`9.5.2`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q199<-ifelse(sette$`9.5.3`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(sette$`9.5.3`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(sette$`9.5.3`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q200<-ifelse(sette$`9.5.4`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(sette$`9.5.4`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(sette$`9.5.4`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q201<-ifelse(sette$`9.5.5`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(sette$`9.5.5`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(sette$`9.5.5`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Hvordan rengjøres og desinfiseres utstyr, generelt sett?
# q202<-ifelse(sette$`9.5.6`=="Spyling av utstyret for å fjerne synlig materiale (feks med børster, kraftig/stor slange mm).",0, ifelse(sette$`9.5.6`=="Spyling og vask av utstyret med vaskemiddel",0.5,ifelse(sette$`9.5.6`=="Spyling, vask og desinfeksjon av utstyret",1,0)))
# #Ved sykdomsutbrudd, benyttes utstyr som kun skal brukes på områder av lokaliteten som er smittet?
# q203<-ifelse(sette$`9.6`=="Ja",1,0)
# #Blir utstyret vasket (tanker / fartøyer / produksjonslinjer eller lignende) eller lar merdene stå tomme i en lengre periode etter at den syke / døde fisken er fjernet?
# q204<-ifelse(sette$`9.6999999999999993`=="Ja",1,0)
# #Hvilken beskyttelses-bekledning må personalet ha på seg, når de arbeider i anlegget?Overall/kjeledress, forkle (engangs- eller ikke-engangs)
# q205<-ifelse(sette$`11.5.1`=="Ja",1,0)
# #Hvilken beskyttelses-bekledning må personalet ha på seg, når de arbeider i anlegget? Fottøy
# q206<-ifelse(sette$`11.5.2`=="Ja",1,0)
# #Hvilken beskyttelses-bekledning må personalet ha på seg, når de arbeider i anlegget? Hansker
# q207<-ifelse(sette$`11.5.3`=="Ja",1,0)
# # Hvor ofte vaskes beskyttelses-bekledningen?
# q208<-ifelse(sette$`11.6`=="Minst en gang daglig",1,ifelse(sette$`11.6`=="Minst en gang i uken",0.5,0))
# #Hvor ofte desinfiseres beskyttelses-bekledning?
# q209<-ifelse(sette$`11.7`=="Minst en gang daglig",1,ifelse(sette$`11.7`=="Minst en gang i uken",0.5,0))
# #Benyttes spesielle og lett gjenkjennelige klær (feks med fargekoder) for hver av de ulike produksjonsenhetene på samme lokalitet?
# q210<-ifelse(sette$`11.9`=="Ja",1,0)
# # Finnes egne separate områder, innredninger, fasiliteter, utstyr og personell, som benyttes for håndtering av syk fisk?
# q211<-ifelse(sette$`16.8.1`=="Ja",1,0)
# # Finnes egne separate områder, innredninger, fasiliteter, utstyr og personell, som benyttes for håndtering av syk fisk?
# q212<-ifelse(sette$`16.8.2`=="Ja",1,0)
# # Finnes egne separate områder, innredninger, fasiliteter, utstyr og personell, som benyttes for håndtering av syk fisk?
# q213<- ifelse(sette$`16.8.3`=="Ja",1,0)
# #Hvis det ikke er mulig å benytte separate fasiliteter, utstyr og personell ved håndtering av syk fisk: Undersøkes og håndteres syk fisk til slutt?
# q214<-ifelse(sette$`16.899999999999999`=="Ja",1,0)
# #Vaskes og desinfiseres alt av utstyr, klær, støvler etc, som kommer i kontakt med syk fisk?
# q215<-ifelse(sette$`16.10`=="Ja",1,0)
# # Skal personale alltid vaske og desinfisere hendene etter kontakt med syk og død fisk?
# q216<-ifelse(sette$`16.11`=="Ja",1,0)
#  
# 
# 
# #weight of the questions
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
# sub13<-rowSums(cbind(q191*w191,q192*w192,q193*w193,q194*w194,q195*w195,q196*w196,q197*w197,q198*w198,q199*w199,q200*w200,q201*w201,q202*w202,q203*w203,q204*w204,q205*w205,q206*w206,q207*w207,q208*w208,q209*w209,q210*w210,q211*w211,q212*w212,q213*w213,q214*w214,q215*w215,q216*w216), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 26)
# su1.13<-(sub13/26)*100
# su1.13
# 
# #mean of the scores for this subcategory
# msu1.13<-mean(su1.13)
# msu1.13
# 
# summary(su1.13)  
#  
# 
#  #14)BIOSECURITY PROGRAM AND RECORD KEEPING
# 
#  #Har lokaliteten egen standard prosedyre for biosikkerhet (SOPs)?
#  q217<-ifelse(sette$`18.100000000000001`=="Ja",1,0)
#  #Hvor ofte får medarbeiderne gjennomgang og opplæring i biosikkerhetsprosedyren (SOP'en)?
#  q218<-ifelse(sette$`18.2`=="Minst en gang i året",1,ifelse(sette$`18.2`=="Minst en gang hvert andre år",0.5,ifelse(sette$`18.2`=="Minst en gang hvert tredje år",0.2,0)))
#  #Revideres denne lokaliteten regelmessig vha kvalitetsprogram som feks "Friends of the Sea", "GlobalGAP", etc ?
#  q219<-ifelse(sette$`18.3`=="Ja",1,0)
#  #Hvor ofte revideres biosikkerhetsprosedyren?
#  q220<-ifelse(sette$`18.399999999999999`=="Minst en gang i året",1,ifelse(sette$`18.399999999999999`=="Minst en gang hvert andre år",0.5,ifelse(sette$`18.399999999999999`=="Minst en gang hvert tredje år",0.2,0)))
#  # Registreres data fra følgende deler av virksomheten?
#  q221<-ifelse(sette$`18.5.1`=="Ja",1,0)
#  # Registreres data fra følgende deler av virksomheten?
#  q222<-ifelse(sette$`18.5.2`=="Ja",1,0)
#  # Registreres data fra følgende deler av virksomheten?
#  q223<-ifelse(sette$`18.5.3`=="Ja",1,0)
#  # Registreres data fra følgende deler av virksomheten?
#  q224<-ifelse(sette$`18.5.4`=="Ja",1,0)
#  # Registreres data fra følgende deler av virksomheten?
#  q225<-ifelse(sette$`18.5.5`=="Ja",1,0)
#  
#  #weight of the questions
#  w217<-1
#  w218<-1
#  w219<-1
#  w220<-1
#  w221<-1
#  w222<-1
#  w223<-1
#  w224<-1
#  w225<-1
#  
#  
#  
#    
# sub14<-rowSums(cbind(q217*w217,q218*w218,q219*w219,q220*w220,q221*w221,q222*w222,q223*w223,q224*w224,q225*w225), na.rm=TRUE)
# 
# #(as each question as a weigth of 1 the maximum score of this subcategory is 9)
# su1.14<-(sub14/9)*100
# su1.14
# 
# #mean of the scores for this subcategory
# msu1.14<-mean(su1.14)
# msu1.14
# 
# summary(su1.14)   
#  
# 
# #Wheights for the subcategories
#  ws1<-1
#  ws2<-1
#  ws3<-1
#  ws4<-1
#  ws5<-1
#  ws6<-1
#  ws7<-1
#  ws8<-1
#  ws9<-1
#  ws10<-1
#  ws11<-1
#  ws12<-1
#  ws13<-1
#  ws14<-1
# 
#  
#  
# #Subtotal of external biosecurity
#    
# external<-rowSums(cbind(su1.1*ws1,su1.2*ws2,su1.3*ws3,su1.4*ws4,su1.5*ws5,su1.6*ws6,su1.7*ws7), na.rm=TRUE)
# ext<-external/7
# ext
#  
# #mean score for external biosecurity
# mext<-mean(ext)
# mext
# summary(ext)
#  
# 
#  
# #Subtotal of internal biosecurity
# internal<-rowSums(cbind(su1.8*ws8,su1.9*ws9,su1.10*ws10,su1.11*ws11,su1.12*ws12,su1.13*ws13,su1.14*ws14), na.rm=TRUE)
# int<-internal/7
# int
# 
# #mean score for internal biosecurity
#  mint<-mean(int)
#  mint
#  summary(int)
#  
#  
#  
# #Not to use now
#  total<-rowSums(cbind(su1.1*ws1,su1.2*ws2,su1.3*ws3,su1.4*ws4,su1.5*ws5,su1.6*ws6,su1.7*ws7,su1.8*ws8,su1.9*ws9,su1.10*ws10,su1.11*ws11,su1.12*ws12,su1.13*ws13,su1.14*ws14), na.rm=TRUE)
#  tot<-(total/14)
#  tot
#  summary(tot)
#  
#  
# #Overall biosecurity 
#  
# #we have to give weigth ro each category
#  we<-0.5
#  wi<-0.5
#  
#  total<-round((ext*we)+(int*wi))
#  
#  total
#  
#  #Mean of overall scores
#  mtotal<-mean(total)
#  mtotal
#  summary(total)
#  
#  
#  #Data for APP
#  myscore<-rbind(su1.1,su1.2,su1.3,su1.4,su1.5,su1.6,su1.7,ext,su1.8,su1.9,su1.10,su1.11,su1.12,su1.13,su1.14,int,total)
#  myscore
#  
#  meanscore<-rbind(msu1.1,msu1.2,msu1.3,msu1.4,msu1.5,msu1.6,msu1.7,mext,msu1.8,msu1.9,msu1.10,msu1.11,msu1.12,msu1.13,msu1.14,mint,mtotal)
#  meanscore
#  
#  benchmarking<-cbind(myscore,meanscore)
#  benchmarking
#  