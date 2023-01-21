"""empty message

Revision ID: af4b030a58cf
Revises: 
Create Date: 2023-01-21 17:32:54.432929

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'af4b030a58cf'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('post',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('body', sa.String(length=140), nullable=True),
    sa.Column('timestamp', sa.DateTime(), nullable=True),
    sa.Column('user_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['user.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    with op.batch_alter_table('post', schema=None) as batch_op:
        batch_op.create_index(batch_op.f('ix_post_timestamp'), ['timestamp'], unique=False)

    op.drop_table('classroom')
    op.drop_table('many_courses_has_many_students')
    op.drop_table('course')
    op.drop_table('many_lessons_has_many_students')
    op.drop_table('lesson')
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.add_column(sa.Column('username', sa.String(length=64), nullable=True))
        batch_op.add_column(sa.Column('about_me', sa.String(length=140), nullable=True))
        batch_op.add_column(sa.Column('last_seen', sa.DateTime(), nullable=True))
        batch_op.alter_column('email',
               existing_type=sa.CHAR(length=120),
               type_=sa.String(length=120),
               nullable=True)
        batch_op.alter_column('password_hash',
               existing_type=sa.CHAR(length=128),
               type_=sa.String(length=128),
               nullable=True)
        batch_op.alter_column('is_active',
               existing_type=sa.BOOLEAN(),
               nullable=True,
               existing_server_default=sa.text('true'))
        batch_op.drop_index('user_email_index')
        batch_op.drop_constraint('user_email_unique', type_='unique')
        batch_op.create_index(batch_op.f('ix_user_email'), ['email'], unique=True)
        batch_op.create_index(batch_op.f('ix_user_username'), ['username'], unique=True)
        batch_op.drop_column('name')
        batch_op.drop_column('password')
        batch_op.drop_column('is_teacher')
        batch_op.drop_column('surname')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.add_column(sa.Column('surname', sa.CHAR(length=40), autoincrement=False, nullable=True))
        batch_op.add_column(sa.Column('is_teacher', sa.BOOLEAN(), server_default=sa.text('false'), autoincrement=False, nullable=False))
        batch_op.add_column(sa.Column('password', sa.CHAR(length=20), autoincrement=False, nullable=True))
        batch_op.add_column(sa.Column('name', sa.CHAR(length=40), autoincrement=False, nullable=True))
        batch_op.drop_index(batch_op.f('ix_user_username'))
        batch_op.drop_index(batch_op.f('ix_user_email'))
        batch_op.create_unique_constraint('user_email_unique', ['email'])
        batch_op.create_index('user_email_index', ['email'], unique=False)
        batch_op.alter_column('is_active',
               existing_type=sa.BOOLEAN(),
               nullable=False,
               existing_server_default=sa.text('true'))
        batch_op.alter_column('password_hash',
               existing_type=sa.String(length=128),
               type_=sa.CHAR(length=128),
               nullable=False)
        batch_op.alter_column('email',
               existing_type=sa.String(length=120),
               type_=sa.CHAR(length=120),
               nullable=False)
        batch_op.drop_column('last_seen')
        batch_op.drop_column('about_me')
        batch_op.drop_column('username')

    op.create_table('lesson',
    sa.Column('id', sa.INTEGER(), server_default=sa.text("nextval('lesson_id_seq'::regclass)"), autoincrement=True, nullable=False),
    sa.Column('secret_token', sa.CHAR(length=8), autoincrement=False, nullable=False),
    sa.Column('title', sa.CHAR(length=40), autoincrement=False, nullable=False),
    sa.Column('description', sa.CHAR(length=1024), autoincrement=False, nullable=True),
    sa.Column('start_date_time', sa.DATE(), autoincrement=False, nullable=True),
    sa.Column('end_date_time', sa.DATE(), autoincrement=False, nullable=True),
    sa.Column('in_presence', sa.BOOLEAN(), server_default=sa.text('true'), autoincrement=False, nullable=False),
    sa.Column('online', sa.BOOLEAN(), server_default=sa.text('true'), autoincrement=False, nullable=False),
    sa.Column('recording_will_be_available', sa.BOOLEAN(), server_default=sa.text('false'), autoincrement=False, nullable=False),
    sa.Column('on_line_link', sa.CHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('on_line_recording_link', sa.CHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('id_course', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('id_classroom', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('id_user', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.CheckConstraint('in_presence OR online', name='lesson_how_check'),
    sa.CheckConstraint('start_date_time < end_date_time', name='lesson_date_time_start_end_check'),
    sa.ForeignKeyConstraint(['id_user'], ['user.id'], name='user_fk', onupdate='CASCADE', ondelete='SET NULL'),
    sa.PrimaryKeyConstraint('id', name='lesson_pkey'),
    postgresql_ignore_search_path=False
    )
    op.create_table('many_lessons_has_many_students',
    sa.Column('id_lesson', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('id_user', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['id_lesson'], ['lesson.id'], name='lesson_fk', onupdate='CASCADE', ondelete='RESTRICT'),
    sa.ForeignKeyConstraint(['id_user'], ['user.id'], name='user_fk', onupdate='CASCADE', ondelete='RESTRICT'),
    sa.PrimaryKeyConstraint('id_lesson', 'id_user', name='many_lessons_has_many_students_pk')
    )
    op.create_table('course',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('title', sa.CHAR(length=128), autoincrement=False, nullable=False),
    sa.Column('description', sa.CHAR(length=1024), autoincrement=False, nullable=True),
    sa.Column('min_ratio_for_attendance_certificate', postgresql.DOUBLE_PRECISION(precision=53), server_default=sa.text('0.75'), autoincrement=False, nullable=True),
    sa.Column('max_in_presence_partecipants', sa.INTEGER(), server_default=sa.text('0'), autoincrement=False, nullable=False),
    sa.Column('id_user', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.CheckConstraint('max_in_presence_partecipants >= 0', name='course_max_in_presence_partecipants_check'),
    sa.CheckConstraint('min_ratio_for_attendance_certificate > (0)::double precision', name='course_ratio_check'),
    sa.ForeignKeyConstraint(['id_user'], ['user.id'], name='user_fk', onupdate='CASCADE', ondelete='SET NULL'),
    sa.PrimaryKeyConstraint('id', name='course_pkey')
    )
    op.create_table('many_courses_has_many_students',
    sa.Column('id_course', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('id_user', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['id_user'], ['user.id'], name='user_fk', onupdate='CASCADE', ondelete='RESTRICT'),
    sa.PrimaryKeyConstraint('id_course', 'id_user', name='many_courses_has_many_students_pk')
    )
    op.create_table('classroom',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('name', sa.CHAR(length=40), autoincrement=False, nullable=False),
    sa.Column('description', sa.CHAR(length=1024), autoincrement=False, nullable=True),
    sa.Column('capacity', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('disability_enabled', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.CheckConstraint('capacity >= 0', name='classroom_capacity_check'),
    sa.PrimaryKeyConstraint('id', name='classroom_pkey'),
    sa.UniqueConstraint('name', name='classroom_name_unique')
    )
    with op.batch_alter_table('post', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_post_timestamp'))

    op.drop_table('post')
    # ### end Alembic commands ###
