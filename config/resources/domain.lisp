(in-package :mu-cl-resources)

(setf *cache-model-properties-p* t)
(defparameter *include-count-in-paginated-responses* t
  "when non-nil, all paginated listings will contain the number
   of responses in the result object's meta.")

;;;;
;; NOTE
;; docker-compose stop; docker-compose rm; docker-compose up
;; after altering this file.

;; Describe your resources here

;; The general structure could be described like this:
;;
;; (define-resource <name-used-in-this-file> ()
;;   :class <class-of-resource-in-triplestore>
;;   :properties `((<json-property-name-one> <type-one> ,<triplestore-relation-one>)
;;                 (<json-property-name-two> <type-two> ,<triplestore-relation-two>>))
;;   :has-many `((<name-of-an-object> :via ,<triplestore-relation-to-objects>
;;                                    :as "<json-relation-property>")
;;               (<name-of-an-object> :via ,<triplestore-relation-from-objects>
;;                                    :inverse t ; follow relation in other direction
;;                                    :as "<json-relation-property>"))
;;   :has-one `((<name-of-an-object :via ,<triplestore-relation-to-object>
;;                                  :as "<json-relation-property>")
;;              (<name-of-an-object :via ,<triplestore-relation-from-object>
;;                                  :as "<json-relation-property>"))
;;   :resource-base (s-url "<string-to-which-uuid-will-be-appended-for-uri-of-new-items-in-triplestore>")
;;   :on-path "<url-path-on-which-this-resource-is-available>")

(define-resource schema-analysis-job ()
  :class (s-prefix "ext:SchemaAnalysisJob")
  :properties `((:created :datetime ,(s-prefix "dct:created")))
  :has-one `((file :via ,(s-prefix "ext:file")
                       :as "file")
             (source :via ,(s-prefix "ext:jobs")
                     :inverse t
                     :as "source"))
  :has-many `((column :via ,(s-prefix "ext:column")
                       :as "columns"))
  :resource-base (s-url "http://example.com/schema-analysis-jobs/")
  :features '(include-uri)
  :on-path "schema-analysis-jobs")

(define-resource column ()
  :class (s-prefix "ext:Column")
  :properties `((:name :string ,(s-prefix "ext:name"))
                (:path :string ,(s-prefix "ext:path"))
                (:description :string ,(s-prefix "ext:description"))
                (:note :string ,(s-prefix "ext:note"))
                (:disable-processing :boolean ,(s-prefix "ext:disableProcessing"))
                (:data-type :url ,(s-prefix "ext:dataType")) ;; One of https://www.w3.org/TR/xmlschema-2/#built-in-datatypes
                (:quantity-kind :string ,(s-prefix "ext:quantityKind")) ;; See http://www.qudt.org/pages/HomePage.html later on
                (:unit :string ,(s-prefix "ext:unit")) ;; See http://www.qudt.org/pages/HomePage.html later on
                ;; Mini-analysis below. Should become part of other entity eventually
                (:record-count :number ,(s-prefix "ext:recordCount"))
                (:missing-count :number ,(s-prefix "ext:missingCount"))
                (:null-count :number ,(s-prefix "ext:nullCount"))
                (:min :number ,(s-prefix "ext:min"))
                (:max :number ,(s-prefix "ext:max"))
                (:mean :number ,(s-prefix "ext:mean"))
                (:median :number ,(s-prefix "ext:median"))
                (:common-values :string ,(s-prefix "ext:commonValues")))
  :has-one `((schema-analysis-job :via ,(s-prefix "ext:column")
                   :inverse t
                    :as "column")
             (unit              :via        ,(s-prefix "ext:unit")
                                :as "unit"))
  :resource-base (s-url "http://example.com/columns/")
  :features '(include-uri)
  :on-path "columns")

  (define-resource source ()
    :class (s-prefix "ext:Source")
    :properties `((:name          :string     ,(s-prefix "ext:name"))
                  (:created       :datetime   ,(s-prefix "dct:created"))
                  (:description   :string     ,(s-prefix "ext:description"))
                  (:note :string ,(s-prefix "ext:note")))
    :has-many `((schema-analysis-job :via ,(s-prefix "ext:jobs")
                      :as "source")) ;; Hoe het in de API attributen gaat zitten
                      ;; Predicaat dat de relatie gaat predicteren, kan zelf gekozen worden omdat we zelf definieren, lowercase benamingen
    :resource-base (s-url "http://example.com/sources/")
    :features '(include-uri)
    :on-path "sources")

(define-resource file ()
  :class (s-prefix "nfo:FileDataObject")
  :properties `((:filename      :string     ,(s-prefix "nfo:fileName"))
                (:format        :string     ,(s-prefix "dct:format"))
                (:size          :number     ,(s-prefix "nfo:fileSize"))
                (:extension     :string     ,(s-prefix "dbpedia:fileExtension"))
                (:created       :datetime   ,(s-prefix "dct:created"))
                (:content-type  :string     ,(s-prefix "ext:contentType")))
  :has-one `((file              :via        ,(s-prefix "nie:dataSource")
                                :inverse t
                                :as "download"))
  :resource-base (s-url "http://example.com/files/")
  :features `(include-uri)
  :on-path "files")

(define-resource unit ()
  :class (s-prefix "ext:Unit")
  :properties `((:name      :string     ,(s-prefix "ext:unitName"))
                (:notation        :string     ,(s-prefix "ext:unitNotation"))
                (:uri       :url    ,(s-prefix "ext:unitUri"))
                (:definition      :string     ,(s-prefix "ext:unitDefinition")))
  :resource-base (s-url "http://vocab.nerc.ac.uk/collection/P06/current/")
  :has-many `((column :via ,(s-prefix "ext:unit")
  			:inverse t
                       :as "column"))
  :features `(include-uri)
  :on-path "units")
