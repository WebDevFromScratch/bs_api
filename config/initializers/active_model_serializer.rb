# TODO: consider dropping jsonapi.org convention - can be causing more bad than good
# (inconsistencies regarding errors vs success responses)
ActiveModel::Serializer.config.adapter = ActiveModelSerializers::Adapter::JsonApi
