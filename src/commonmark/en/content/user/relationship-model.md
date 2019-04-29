# Relationship model
<!--DHIS2-SECTION-ID:relationship_model-->

A relationship represents a link between two entities in the Tracker-model. A
relationship is considered data in DHIS2 and is based on a Relationship Type,
similar to how a Tracked Entity Instance is based on a Tracked Entity Type.

Relationships always include two entities, and these entities can include Tracked
Entity Instances, Enrollments and Events, and any combination of these. Note
that not all of these combinations are available in the current apps.

In addition, relationships can be defined as unidirectional or bidirectional.
The only functional difference is currently that these requires different levels
of access to create. Unidirectional relationships requires the user to have data
write access to the "from" entity and data read access for the "to" entity,
while bidirectional relationships require data write access for both sides.

## Relationship Type
<!--DHIS2-SECTION-ID:relationship_model_relationship_type-->

A Relationship Type is the definition of the properties a relationship have.
Relationships always consists of two sides, referred to as "from" and "to", and
what entities can be contained for each side is determined by the Relationship
Type. The properties that determine what each can contain are called
constraints, fromConstraint and toConstraint respectively. These constraints are
significant when working with the data later, to understand what a relationship
can and cannot contain.

Each of the constraints defined in the Relationship Type consists of several
properties. The primary property is the relationship entity, which decides what
kind of entities the relationship can contain. The entities can be one of the
following for each constraint:

* Tracked Entity Instance
* Enrollment
* Event

Depending on the kind of relationship entity you select, you can choose
additional limitations for each constraint. The following table explains the
different combinations you can configure:

|                     | Tracked Entity Instance | Enrollment | Event    |
|---------------------|-------------------------|------------|----------|
| Tracked Entity Type | Required                | Optional   | -        |
| Program             | -                       | Required   | -        |
| Program Stage       | -                       | Required   | Optional |

These additional limitations, will require the entity to match the limitation
set before it can be created. For example, if your relationship is between a
mother and a child, both constraints would have their required Tracked Entity
Type set to Person and could optionally set the Enrollment to Maternal Health
Program and Child Program respectively. This way, only Tracked Entity Instances
who are of type Person and who is enrolled in the required program is allowed to
be included in these relationships.

In addition to the constrains a Relationship Type can have, each relationship
can be set to bidirectional, true or false. If the property is set to false, the
relationships are treated as unidirectional. As previously mentioned, the only
functional difference between these relationships are how strict the access is
when creating or updating them - bidirectional being the strictest. Relationships 
are also presented differently in the UI based on whether or not the relationship 
is bidirectional or unidirectional.

One important thing to note about bidirectional relationships, are that the
"from" and "to" sides are still significant in the database, meaning each entity
must match the constraint for that side. However, from a user perspective, which
side each entity is stored as is insignificant.
