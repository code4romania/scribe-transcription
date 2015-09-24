class Workflow
  include Mongoid::Document

  field    :name,                                            type: String
  #TODO: can we delete :key field? --AMS
  field    :key, 				                                     type: String
  field    :label,                                           type: String
  field    :first_task,                                      type: String
  field    :retire_limit,                                    type: Integer,   default: 3
  field    :subject_fetch_limit,                             type: Integer,   default: 10
  field    :subject_set_fetch_limit,                         type: Integer,   default: 10
  field    :generates_subjects,                              type: Boolean,   default: true
  field    :generates_subjects_after,                        type: Integer,   default: 0
  field    :generates_subjects_for,                          type: String,    default: ""
  field    :generates_subjects_max,                          type: Integer
  field    :generates_subjects_method,                       type: String,    default: 'one-per-classification'
  field    :generates_subjects_agreement,                    type: Float,     default: 0.75
  field    :active_subjects,                                 type: Integer,   default: 0
  field    :order,                                           type: Integer,   default: 0

  has_many     :subjects
  has_many     :classifications
  belongs_to   :project

  embeds_many :tasks, class_name: 'WorkflowTask'

  def subject_has_enough_classifications(subject)
    subject.classification_count >= self.generates_subjects_after
  end

  def task_by_key(key)
    tasks.where(key: key).first
  end

  def create_secondary_subjects(classification)
    task = task_by_key classification.task_key
    return if task.nil? || ! task.generates_subjects?(classification)

    # If we're here, this task generates subjects; Pass responsibility off to
    # the configured subject generation method:
    method = SubjectGenerationMethod.by_name classification.workflow.generates_subjects_method
    method.process_classification(classification)
  end

  def next_workflow
    if ! generates_subjects_for.nil?
      Workflow.find_by(name: generates_subjects_for)
    end
  end

  def to_s
    name.capitalize
  end

end
